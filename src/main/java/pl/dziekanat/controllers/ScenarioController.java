package pl.dziekanat.controllers;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.server.ResponseStatusException;

import pl.dziekanat.dto.GraduationResult;
import pl.dziekanat.entities.Grade;
import pl.dziekanat.entities.Student;
import pl.dziekanat.entities.Subject;
import pl.dziekanat.enums.GradeType;
import pl.dziekanat.enums.StudentStatus;
import pl.dziekanat.repositories.GradeRepository;
import pl.dziekanat.repositories.StudentRepository;
import pl.dziekanat.dto.SemesterSettlementResult;

import pl.dziekanat.dto.InstructorPaymentResult;
import pl.dziekanat.entities.Instructor;
import pl.dziekanat.entities.SubjectAssignment;
import pl.dziekanat.repositories.SubjectAssignmentRepository;

@Controller
@RequestMapping("/scenario")
public class ScenarioController {
	
	// === Stawki godzinowe wg tytulu (PLN) - edytuj tutaj w razie potrzeby ===
		private static final Map<String, Double> STAWKI_GODZINOWE = Map.of(
				"prof.", 150.0,
				"dr hab.", 120.0,
				"dr", 100.0,
				"mgr", 80.0
		);

		// stawka godzinowa dla danego tytulu; 0 jesli tytul spoza tabeli
		private double ratePerHour(String title) {
			if (title == null) {
				return 0.0;
			}
			return STAWKI_GODZINOWE.getOrDefault(title, 0.0);
		}

	@Autowired
	StudentRepository studentRepo;

	@Autowired
	GradeRepository gradeRepo;
	
	@Autowired
	SubjectAssignmentRepository assignmentRepo;

	// Scenariusz 1: Ukonczenie studiow przez studenta
	@PostMapping("/graduation")
	public @ResponseBody GraduationResult checkGraduation(@RequestParam String indexNumber) {
		// odszukanie studenta po numerze indeksu
		List<Student> found = studentRepo.findByIndexNumber(indexNumber);
		if (found.isEmpty()) {
			throw new NoSuchElementException();
		}
		Student student = found.get(0);

		// wszystkie oceny studenta
		List<Grade> grades = gradeRepo.findByStudentId(student.getId());

		// oceny semestralne (END) z ostatniego semestru studenta
		List<Grade> endGrades = new ArrayList<>();
		for (Grade g : grades) {
			if (g.getGradeType() == GradeType.END
					&& g.getSubject() != null
					&& g.getSubject().getSemesterNumber().equals(student.getSemester())) {
				endGrades.add(g);
			}
		}

		// dla kazdego przedmiotu zostawiamy tylko najnowsza probe (najwyzszy attemptNumber)
		Map<Long, Grade> latestPerSubject = new HashMap<>();
		for (Grade g : endGrades) {
			Long subjectId = g.getSubject().getId();
			Grade current = latestPerSubject.get(subjectId);
			if (current == null || g.getAttemptNumber() > current.getAttemptNumber()) {
				latestPerSubject.put(subjectId, g);
			}
		}

		// niezaliczone = najnowsza proba ponizej 3.0
		List<Subject> failedSubjects = new ArrayList<>();
		for (Grade g : latestPerSubject.values()) {
			if (g.getValue() < 3.0) {
				failedSubjects.add(g.getSubject());
			}
		}

		GraduationResult result = new GraduationResult();
		result.setFailedSubjects(failedSubjects);
		if (failedSubjects.isEmpty()) {
			student.setStatus(StudentStatus.GRADUATED);
			student.setGraduationDate(LocalDate.now());
			studentRepo.save(student);
			result.setCanGraduate(true);
			result.setMessage("Student moze ukonczyc studia.");
		} else {
			result.setCanGraduate(false);
			result.setMessage("Student nie moze ukonczyc studia - niezaliczone przedmioty z ostatniego semestru.");
		}
		return result;
	}

	// Scenariusz 2: Powrot studenta z urlopu dziekanskiego
	@PostMapping("/return-from-leave")
	public @ResponseBody Student returnFromLeave(@RequestParam String indexNumber,
			@RequestParam Integer semester) {
		// odszukanie studenta po numerze indeksu
		List<Student> found = studentRepo.findByIndexNumber(indexNumber);
		if (found.isEmpty()) {
			throw new NoSuchElementException();
		}
		Student student = found.get(0);

		// powrot mozliwy tylko gdy student jest aktualnie na urlopie dziekanskim
		if (student.getStatus() != StudentStatus.DEAN_LEAVE) {
			throw new ResponseStatusException(HttpStatus.CONFLICT,
					"Student nie jest na urlopie dziekanskim");
		}

		// odnotowanie powrotu: status ACTIVE i reczna korekta semestru
		student.setStatus(StudentStatus.ACTIVE);
		student.setSemester(semester);
		studentRepo.save(student);
		return student;
	}
	// Scenariusz 3: Rozliczenie semestru
		@PostMapping("/semester-settlement")
		public @ResponseBody List<SemesterSettlementResult> settleSemester(@RequestParam String academicYear) {
			List<SemesterSettlementResult> report = new ArrayList<>();

			// wszyscy aktywni studenci
			List<Student> activeStudents = studentRepo.findByStatus(StudentStatus.ACTIVE);

			for (Student student : activeStudents) {
				Integer endedSemester = student.getSemester();

				// oceny END z rozliczanego roku i z konczacego sie semestru studenta
				List<Grade> grades = gradeRepo.findByStudentId(student.getId());
				List<Grade> endGrades = new ArrayList<>();
				for (Grade g : grades) {
					if (g.getGradeType() == GradeType.END
							&& academicYear.equals(g.getAcademicYear())
							&& g.getSubject() != null
							&& g.getSubject().getSemesterNumber().equals(endedSemester)) {
						endGrades.add(g);
					}
				}

				// dla kazdego przedmiotu tylko najnowsza proba (najwyzszy attemptNumber)
				Map<Long, Grade> latestPerSubject = new HashMap<>();
				for (Grade g : endGrades) {
					Long subjectId = g.getSubject().getId();
					Grade current = latestPerSubject.get(subjectId);
					if (current == null || g.getAttemptNumber() > current.getAttemptNumber()) {
						latestPerSubject.put(subjectId, g);
					}
				}

				// niezaliczone = najnowsza proba ponizej 3.0; sumujemy ich ECTS
				List<Subject> failedSubjects = new ArrayList<>();
				int failedEcts = 0;
				for (Grade g : latestPerSubject.values()) {
					if (g.getValue() < 3.0) {
						failedSubjects.add(g.getSubject());
						failedEcts += g.getSubject().getEcts();
					}
				}

				// 30 - suma ECTS niezaliczonych; jesli >= 21 (70% z 30) i semestr != 7 -> inkrementacja
				int remaining = 30 - failedEcts;
				boolean promoted = false;
				if (remaining >= 21 && endedSemester != 7) {
					student.setSemester(endedSemester + 1);
					studentRepo.save(student);
					promoted = true;
				}

				// pozycja raportu - semestr ten, ktory sie skonczyl (przed inkrementacja)
				SemesterSettlementResult row = new SemesterSettlementResult();
				row.setFirstName(student.getFirstName());
				row.setLastName(student.getLastName());
				row.setFieldOfStudy(student.getFieldOfStudy());
				row.setSemester(endedSemester);
				row.setFailedSubjects(failedSubjects);
				row.setPromoted(promoted);
				report.add(row);
			}

			return report;
		}
}