package pl.dziekanat.controllers;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import pl.dziekanat.dto.GraduationResult;
import pl.dziekanat.dto.InstructorNominationCandidate;
import pl.dziekanat.dto.InstructorPaymentResult;
import pl.dziekanat.dto.ProblematicSubjectResult;
import pl.dziekanat.dto.ResignationDetectionResult;
import pl.dziekanat.dto.ScholarshipRankingResult;
import pl.dziekanat.dto.SemesterSettlementResult;
import pl.dziekanat.entities.Grade;
import pl.dziekanat.entities.Instructor;
import pl.dziekanat.entities.Student;
import pl.dziekanat.entities.Subject;
import pl.dziekanat.entities.SubjectAssignment;
import pl.dziekanat.enums.GradeType;
import pl.dziekanat.enums.InstructorRole;
import pl.dziekanat.enums.StudentStatus;
import pl.dziekanat.repositories.GradeRepository;
import pl.dziekanat.repositories.StudentRepository;
import pl.dziekanat.repositories.SubjectAssignmentRepository;

@RestController
@RequestMapping("/scenario")
public class ScenarioController {

	private Map<Long, Grade> latestEndGradesForSemester(List<Grade> grades, Integer semester) {
		Map<Long, Grade> result = new HashMap<>();
		for (Grade g : grades) {
			if (g.getGradeType() != GradeType.END) continue;
			if (g.getSubject() == null) continue;
			if (!g.getSubject().getSemesterNumber().equals(semester)) continue;
			Long sid = g.getSubject().getId();
			Grade cur = result.get(sid);
			if (cur == null || g.getAttemptNumber() > cur.getAttemptNumber())
				result.put(sid, g);
		}
		return result;
	}

	private Map<Long, Grade> latestEndGradesForSemester(List<Grade> grades, String academicYear, Integer semester) {
		Map<Long, Grade> result = new HashMap<>();
		for (Grade g : grades) {
			if (g.getGradeType() != GradeType.END) continue;
			if (g.getSubject() == null) continue;
			if (!academicYear.equals(g.getAcademicYear())) continue;
			if (!g.getSubject().getSemesterNumber().equals(semester)) continue;
			Long sid = g.getSubject().getId();
			Grade cur = result.get(sid);
			if (cur == null || g.getAttemptNumber() > cur.getAttemptNumber())
				result.put(sid, g);
		}
		return result;
	}

	// stawki godzinowe wg tytulu (PLN) - edytuj tutaj w razie potrzeby
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
	public GraduationResult checkGraduation(@RequestParam String indexNumber) {
		List<Student> found = studentRepo.findByIndexNumber(indexNumber);
		if (found.isEmpty()) {
			throw new NoSuchElementException();
		}
		Student student = found.get(0);

		List<Grade> grades = gradeRepo.findByStudentId(student.getId());
		Map<Long, Grade> latestPerSubject = latestEndGradesForSemester(grades, student.getSemester());

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
	public Student returnFromLeave(@RequestParam String indexNumber,
			@RequestParam Integer semester) {
		List<Student> found = studentRepo.findByIndexNumber(indexNumber);
		if (found.isEmpty()) {
			throw new NoSuchElementException();
		}
		Student student = found.get(0);

		if (student.getStatus() != StudentStatus.DEAN_LEAVE) {
			throw new ResponseStatusException(HttpStatus.CONFLICT,
					"Student nie jest na urlopie dziekanskim");
		}

		student.setStatus(StudentStatus.ACTIVE);
		student.setSemester(semester);
		studentRepo.save(student);
		return student;
	}

	// Scenariusz 3: Rozliczenie semestru
	@PostMapping("/semester-settlement")
	public List<SemesterSettlementResult> settleSemester(@RequestParam String academicYear) {
		List<SemesterSettlementResult> report = new ArrayList<>();

		for (Student student : studentRepo.findByStatus(StudentStatus.ACTIVE)) {
			Integer endedSemester = student.getSemester();

			List<Grade> grades = gradeRepo.findByStudentId(student.getId());
			Map<Long, Grade> latestPerSubject = latestEndGradesForSemester(grades, academicYear, endedSemester);

			List<Subject> failedSubjects = new ArrayList<>();
			int failedEcts = 0;
			for (Grade g : latestPerSubject.values()) {
				if (g.getValue() < 3.0) {
					failedSubjects.add(g.getSubject());
					failedEcts += g.getSubject().getEcts();
				}
			}

			// warunek promocji: zaliczone co najmniej 70% ECTS semestru (21/30)
			boolean promoted = false;
			if ((30 - failedEcts) >= 21 && endedSemester != 7) {
				student.setSemester(endedSemester + 1);
				studentRepo.save(student);
				promoted = true;
			}

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

	// Scenariusz 4: Wyplata za zajecia dla instruktora
	@PostMapping("/instructor-payment")
	public List<InstructorPaymentResult> instructorPayment(@RequestParam String academicYear) {
		List<SubjectAssignment> assignments = assignmentRepo.findByAcademicYear(academicYear);

		Map<Long, Integer> hoursByInstructor = new HashMap<>();
		Map<Long, Instructor> instructorsById = new HashMap<>();
		for (SubjectAssignment sa : assignments) {
			Instructor instructor = sa.getInstructor();
			if (instructor == null) continue;
			Long id = instructor.getId();
			instructorsById.put(id, instructor);
			hoursByInstructor.merge(id, sa.getHoursPerWeek(), Integer::sum);
		}

		// wynagrodzenie miesieczne = suma godzin tygodniowych * 4 tygodnie * stawka wg tytulu
		List<InstructorPaymentResult> report = new ArrayList<>();
		for (Long id : instructorsById.keySet()) {
			Instructor instructor = instructorsById.get(id);
			int totalHours = hoursByInstructor.get(id);

			InstructorPaymentResult row = new InstructorPaymentResult();
			row.setFirstName(instructor.getFirstName());
			row.setLastName(instructor.getLastName());
			row.setTitle(instructor.getTitle());
			row.setHoursPerWeek(totalHours);
			row.setSalary(totalHours * 4 * ratePerHour(instructor.getTitle()));
			report.add(row);
		}

		return report;
	}

	// Scenariusz 5: Ranking studentow i stypendia
	@PostMapping("/scholarship-ranking")
	public List<ScholarshipRankingResult> scholarshipRanking(@RequestParam String fieldOfStudy) {
		List<ScholarshipRankingResult> report = new ArrayList<>();

		for (Student student : studentRepo.findByFieldOfStudy(fieldOfStudy)) {
			if (student.getStatus() != StudentStatus.ACTIVE) continue;

			Integer prevSemester = student.getSemester() - 1;
			List<Grade> grades = gradeRepo.findByStudentId(student.getId());
			Map<Long, Grade> latestPerSubject = latestEndGradesForSemester(grades, prevSemester);

			// srednia wazona liczona wzgledem pelnej puli 30 ECTS semestru
			double sum = 0;
			for (Grade g : latestPerSubject.values()) {
				sum += g.getValue() * g.getSubject().getEcts();
			}

			ScholarshipRankingResult row = new ScholarshipRankingResult();
			row.setFirstName(student.getFirstName());
			row.setLastName(student.getLastName());
			row.setIndexNumber(student.getIndexNumber());
			row.setFieldOfStudy(student.getFieldOfStudy());
			row.setWeightedAverage(sum / 30.0);
			report.add(row);
		}

		report.sort((a, b) -> Double.compare(b.getWeightedAverage(), a.getWeightedAverage()));
		return report.size() > 10 ? report.subList(0, 10) : report;
	}

	// Scenariusz 6: Identyfikacja przedmiotow problemowych
	@PostMapping("/problematic-subjects")
	public List<ProblematicSubjectResult> problematicSubjects(
			@RequestParam List<String> academicYears,
			@RequestParam double threshold) {

		// stats[0] = wszystkie oceny z 1. podejscia, stats[1] = oblane
		Map<Long, Map<String, int[]>> subjectYearStats = new HashMap<>();
		Map<Long, Subject> subjectsById = new HashMap<>();

		for (String year : academicYears) {
			for (Grade g : gradeRepo.findByAcademicYearAndGradeType(year, GradeType.END)) {
				if (g.getAttemptNumber() == null || g.getAttemptNumber() != 1) continue;
				if (g.getSubject() == null) continue;

				Long subjectId = g.getSubject().getId();
				subjectsById.put(subjectId, g.getSubject());

				int[] stats = subjectYearStats
						.computeIfAbsent(subjectId, k -> new HashMap<>())
						.computeIfAbsent(year, k -> new int[2]);
				stats[0]++;
				if (g.getValue() != null && g.getValue() < 3.0) stats[1]++;
			}
		}

		List<ProblematicSubjectResult> report = new ArrayList<>();

		for (Long subjectId : subjectYearStats.keySet()) {
			Map<String, int[]> yearStats = subjectYearStats.get(subjectId);

			// kwalifikuje sie tylko gdy przekracza prog we WSZYSTKICH analizowanych latach
			boolean qualifies = true;
			Map<String, Double> failureRateByYear = new LinkedHashMap<>();

			for (String year : academicYears) {
				int[] stats = yearStats.get(year);
				if (stats == null || stats[0] == 0) { qualifies = false; break; }
				double rate = (double) stats[1] / stats[0];
				failureRateByYear.put(year, Math.round(rate * 1000.0) / 10.0);
				if (rate < threshold) qualifies = false;
			}

			if (!qualifies) continue;

			Set<String> instructorNames = new LinkedHashSet<>();
			for (SubjectAssignment sa : assignmentRepo.findBySubjectId(subjectId)) {
				if (!academicYears.contains(sa.getAcademicYear())) continue;
				Instructor instructor = sa.getInstructor();
				if (instructor == null) continue;
				String name = (instructor.getTitle() != null ? instructor.getTitle() + " " : "")
						+ instructor.getFirstName() + " " + instructor.getLastName();
				instructorNames.add(name);
			}

			Subject subject = subjectsById.get(subjectId);
			ProblematicSubjectResult row = new ProblematicSubjectResult();
			row.setSubjectName(subject.getName());
			row.setSemesterNumber(subject.getSemesterNumber());
			row.setEcts(subject.getEcts());
			row.setInstructors(new ArrayList<>(instructorNames));
			row.setFailureRateByYear(failureRateByYear);
			report.add(row);
		}

		return report;
	}

	// Scenariusz 7: Detekcja rezygnacji
	@PostMapping("/resignation-detection")
	public List<ResignationDetectionResult> resignationDetection(
			@RequestParam String academicYear) {

		Set<Long> studentIdsWithGrades = new HashSet<>();
		for (Grade g : gradeRepo.findByAcademicYear(academicYear)) {
			if (g.getStudent() != null) studentIdsWithGrades.add(g.getStudent().getId());
		}

		// swiezo zapisani (< 3 mies.) sa wykluczani - mogli jeszcze nie miec ocen
		LocalDate cutoffDate = LocalDate.now().minusMonths(3);

		List<ResignationDetectionResult> report = new ArrayList<>();
		for (Student student : studentRepo.findByStatus(StudentStatus.ACTIVE)) {
			if (studentIdsWithGrades.contains(student.getId())) continue;
			if (student.getEnrollmentDate() != null
					&& student.getEnrollmentDate().isAfter(cutoffDate)) continue;

			Optional<Grade> lastGrade =
					gradeRepo.findFirstByStudentIdOrderByDateIssuedDesc(student.getId());

			ResignationDetectionResult row = new ResignationDetectionResult();
			row.setIndexNumber(student.getIndexNumber());
			row.setFirstName(student.getFirstName());
			row.setLastName(student.getLastName());
			row.setEmail(student.getEmail());
			row.setSemester(student.getSemester());
			row.setLastGradeDate(lastGrade.map(Grade::getDateIssued).orElse(null));
			report.add(row);
		}

		report.sort((a, b) -> {
			if (a.getLastGradeDate() == null && b.getLastGradeDate() == null) return 0;
			if (a.getLastGradeDate() == null) return 1;
			if (b.getLastGradeDate() == null) return -1;
			return b.getLastGradeDate().compareTo(a.getLastGradeDate());
		});

		return report;
	}

	// wyklad wymaga co najmniej doktoratu; cwiczenia i lab - wystarczy mgr
	private boolean titleQualifiesForRole(String title, InstructorRole role) {
		if (title == null) return false;
		if (role == InstructorRole.LECTURER)
			return title.equals("prof.") || title.equals("dr hab.") || title.equals("dr");
		return title.equals("prof.") || title.equals("dr hab.")
				|| title.equals("dr") || title.equals("mgr");
	}

	// Scenariusz 8: Nominacja prowadzacego przedmiotu w nowym roku akademickim
	@PostMapping("/nominate-instructor")
	public List<InstructorNominationCandidate> nominateInstructor(
			@RequestParam Long subjectId,
			@RequestParam InstructorRole role,
			@RequestParam String academicYear,
			@RequestParam(defaultValue = "20") int maxHoursPerWeek) {

		Map<Long, Set<String>> instructorYears = new HashMap<>();
		Map<Long, Instructor> instructorsById = new HashMap<>();
		for (SubjectAssignment sa : assignmentRepo.findBySubjectId(subjectId)) {
			if (academicYear.equals(sa.getAcademicYear())) continue;
			Instructor instructor = sa.getInstructor();
			if (instructor == null) continue;
			instructorsById.put(instructor.getId(), instructor);
			instructorYears
					.computeIfAbsent(instructor.getId(), k -> new HashSet<>())
					.add(sa.getAcademicYear());
		}

		List<InstructorNominationCandidate> candidates = new ArrayList<>();

		for (Long instructorId : instructorYears.keySet()) {
			Instructor instructor = instructorsById.get(instructorId);
			if (!titleQualifiesForRole(instructor.getTitle(), role)) continue;

			int totalHours = 0;
			for (SubjectAssignment sa : assignmentRepo.findByInstructorIdAndAcademicYear(instructorId, academicYear)) {
				if (sa.getHoursPerWeek() != null) totalHours += sa.getHoursPerWeek();
			}
			if (totalHours >= maxHoursPerWeek) continue;

			InstructorNominationCandidate candidate = new InstructorNominationCandidate();
			candidate.setFirstName(instructor.getFirstName());
			candidate.setLastName(instructor.getLastName());
			candidate.setTitle(instructor.getTitle());
			candidate.setYearsWithSubject(instructorYears.get(instructorId).size());
			candidate.setHoursAlreadyPlanned(totalHours);
			candidates.add(candidate);
		}

		// najpierw najwieksze doswiadczenie z przedmiotem, przy remisie najmniejsze obciazenie
		candidates.sort((a, b) -> {
			int cmp = Integer.compare(b.getYearsWithSubject(), a.getYearsWithSubject());
			if (cmp != 0) return cmp;
			return Integer.compare(a.getHoursAlreadyPlanned(), b.getHoursAlreadyPlanned());
		});

		return candidates;
	}

}