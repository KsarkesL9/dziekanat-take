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
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
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

@Controller
@RequestMapping("/scenario")
public class ScenarioController {

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
	public @ResponseBody GraduationResult checkGraduation(@RequestParam String indexNumber) {
		// odszukanie studenta po numerze indeksu
		List<Student> found = studentRepo.findByIndexNumber(indexNumber);
		if (found.isEmpty()) {
			throw new NoSuchElementException();
		}
		Student student = found.get(0);

		// wszystkie oceny studenta
		List<Grade> grades = gradeRepo.findByStudentId(student.getId());

		// oceny semestralne z ostatniego semestru studenta
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

		// niezaliczone to najnowsza proba ponizej 3.0
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

		// odnotowanie powrotu status ACTIVE i reczna korekta semestru
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

			// niezaliczone = najnowsza proba ponizej 3.0 sumujemy ich ECTS
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

			// pozycja raportu - semestr ten ktory sie skonczyl (przed inkrementacja)
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
	public @ResponseBody List<InstructorPaymentResult> instructorPayment(@RequestParam String academicYear) {
		// wszystkie obsady w danym roku akademickim (obojetna rola)
		List<SubjectAssignment> assignments = assignmentRepo.findByAcademicYear(academicYear);

		// sumujemy godziny tygodniowo per instruktor
		Map<Long, Integer> hoursByInstructor = new HashMap<>();
		Map<Long, Instructor> instructorsById = new HashMap<>();
		for (SubjectAssignment sa : assignments) {
			Instructor instructor = sa.getInstructor();
			if (instructor == null) {
				continue;
			}
			Long id = instructor.getId();
			instructorsById.put(id, instructor);
			int current = hoursByInstructor.getOrDefault(id, 0);
			hoursByInstructor.put(id, current + sa.getHoursPerWeek());
		}

		// raport: wynagrodzenie = suma godzin * 4 * stawka wg tytulu
		List<InstructorPaymentResult> report = new ArrayList<>();
		for (Long id : instructorsById.keySet()) {
			Instructor instructor = instructorsById.get(id);
			int totalHours = hoursByInstructor.get(id);
			double salary = totalHours * 4 * ratePerHour(instructor.getTitle());

			InstructorPaymentResult row = new InstructorPaymentResult();
			row.setFirstName(instructor.getFirstName());
			row.setLastName(instructor.getLastName());
			row.setTitle(instructor.getTitle());
			row.setHoursPerWeek(totalHours);
			row.setSalary(salary);
			report.add(row);
		}

		return report;
	}

	// Scenariusz 5: Ranking studentow i stypendia
	@PostMapping("/scholarship-ranking")
	public @ResponseBody List<ScholarshipRankingResult> scholarshipRanking(@RequestParam String fieldOfStudy) {
		List<ScholarshipRankingResult> report = new ArrayList<>();

		// studenci danego kierunku tylko aktywni
		List<Student> studentsInField = studentRepo.findByFieldOfStudy(fieldOfStudy);
		for (Student student : studentsInField) {
			if (student.getStatus() != StudentStatus.ACTIVE) {
				continue;
			}

			// oceny END z poprzedniego semestru studenta
			Integer prevSemester = student.getSemester() - 1;
			List<Grade> grades = gradeRepo.findByStudentId(student.getId());
			List<Grade> endGrades = new ArrayList<>();
			for (Grade g : grades) {
				if (g.getGradeType() == GradeType.END
						&& g.getSubject() != null
						&& g.getSubject().getSemesterNumber().equals(prevSemester)) {
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

			// srednia wazona = suma(ocena * ects) / 30
			double sum = 0;
			for (Grade g : latestPerSubject.values()) {
				sum += g.getValue() * g.getSubject().getEcts();
			}
			double weightedAverage = sum / 30.0;

			ScholarshipRankingResult row = new ScholarshipRankingResult();
			row.setFirstName(student.getFirstName());
			row.setLastName(student.getLastName());
			row.setIndexNumber(student.getIndexNumber());
			row.setFieldOfStudy(student.getFieldOfStudy());
			row.setWeightedAverage(weightedAverage);
			report.add(row);
		}

		// sortujemy malejaco po sredniej i bierzemy 10 najlepszych
		report.sort((a, b) -> Double.compare(b.getWeightedAverage(), a.getWeightedAverage()));
		if (report.size() > 10) {
			return report.subList(0, 10);
		}
		return report;
	}

	// Scenariusz 6: Identyfikacja przedmiotow problemowych
	@PostMapping("/problematic-subjects")
	public @ResponseBody List<ProblematicSubjectResult> problematicSubjects(
			@RequestParam List<String> academicYears,
			@RequestParam double threshold) {

		// dla kazdego przedmiotu i roku zliczamy liczbe ocen END (tylko proba 1) i liczbe oblanych
		Map<Long, Map<String, int[]>> subjectYearStats = new HashMap<>();
		Map<Long, Subject> subjectsById = new HashMap<>();

		for (String year : academicYears) {
			List<Grade> grades = gradeRepo.findByAcademicYearAndGradeType(year, GradeType.END);
			for (Grade g : grades) {
				// bierzemy tylko pierwsze podejscia
				if (g.getAttemptNumber() == null || g.getAttemptNumber() != 1) continue;
				if (g.getSubject() == null) continue;

				Long subjectId = g.getSubject().getId();
				subjectsById.put(subjectId, g.getSubject());

				subjectYearStats
						.computeIfAbsent(subjectId, k -> new HashMap<>())
						.computeIfAbsent(year, k -> new int[2]);

				int[] stats = subjectYearStats.get(subjectId).get(year);
				stats[0]++; // wszystkie oceny
				if (g.getValue() != null && g.getValue() < 3.0) stats[1]++; // oblane
			}
		}

		List<ProblematicSubjectResult> report = new ArrayList<>();

		for (Long subjectId : subjectYearStats.keySet()) {
			Map<String, int[]> yearStats = subjectYearStats.get(subjectId);

			// przedmiot kwalifikuje sie tylko gdy ma dane w kazdym analizowanym roku
			// i w kazdym z nich odsetek oblanych przekracza prog
			boolean qualifies = true;
			Map<String, Double> failureRateByYear = new LinkedHashMap<>();

			for (String year : academicYears) {
				int[] stats = yearStats.get(year);
				if (stats == null || stats[0] == 0) {
					qualifies = false;
					break;
				}
				double rate = (double) stats[1] / stats[0];
				// odsetek niezdawalnosci w procentach, zaokraglony do jednego miejsca
				failureRateByYear.put(year, Math.round(rate * 1000.0) / 10.0);
				if (rate < threshold) {
					qualifies = false;
				}
			}

			if (!qualifies) continue;

			// prowadzacy w analizowanym okresie
			Set<String> instructorNames = new LinkedHashSet<>();
			List<SubjectAssignment> assignments = assignmentRepo.findBySubjectId(subjectId);
			for (SubjectAssignment sa : assignments) {
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
	public @ResponseBody List<ResignationDetectionResult> resignationDetection(
			@RequestParam String academicYear) {

		// zbieramy id studentow, ktorzy maja jakikolwiek wpis oceny w danym roku
		List<Grade> gradesInYear = gradeRepo.findByAcademicYear(academicYear);
		Set<Long> studentIdsWithGrades = new HashSet<>();
		for (Grade g : gradesInYear) {
			if (g.getStudent() != null) {
				studentIdsWithGrades.add(g.getStudent().getId());
			}
		}

		// granica 3 miesiecy - swiezo zapisani studenci sa wykluczani
		LocalDate cutoffDate = LocalDate.now().minusMonths(3);

		List<ResignationDetectionResult> report = new ArrayList<>();
		List<Student> activeStudents = studentRepo.findByStatus(StudentStatus.ACTIVE);

		for (Student student : activeStudents) {
			// wyklucz jesli ma jakikolwiek wpis oceny w danym roku
			if (studentIdsWithGrades.contains(student.getId())) continue;
			// wyklucz swiezo zapisanych (mniej niz 3 miesiace temu)
			if (student.getEnrollmentDate() != null
					&& student.getEnrollmentDate().isAfter(cutoffDate)) continue;

			// data ostatniej oceny w calej historii (null = brak ocen)
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

		// sortuj malejaco po dacie ostatniej oceny (brak ocen na koniec)
		report.sort((a, b) -> {
			if (a.getLastGradeDate() == null && b.getLastGradeDate() == null) return 0;
			if (a.getLastGradeDate() == null) return 1;
			if (b.getLastGradeDate() == null) return -1;
			return b.getLastGradeDate().compareTo(a.getLastGradeDate());
		});

		return report;
	}

	// pomocnicza metoda: czy dany tytul kwalifikuje prowadzacego do roli
	private boolean titleQualifiesForRole(String title, InstructorRole role) {
		if (title == null) return false;
		if (role == InstructorRole.LECTURER) {
			// wyklad: co najmniej stopien doktora
			return title.equals("prof.") || title.equals("dr hab.") || title.equals("dr");
		}
		// cwiczenia i laboratorium: kazdy tytul (w tym mgr)
		return title.equals("prof.") || title.equals("dr hab.")
				|| title.equals("dr") || title.equals("mgr");
	}

	// Scenariusz 8: Nominacja prowadzacego przedmiotu w nowym roku akademickim
	@PostMapping("/nominate-instructor")
	public @ResponseBody List<InstructorNominationCandidate> nominateInstructor(
			@RequestParam Long subjectId,
			@RequestParam InstructorRole role,
			@RequestParam String academicYear,
			@RequestParam(defaultValue = "20") int maxHoursPerWeek) {

		// wszystkie przeszle obsady tego przedmiotu (bez docelowego roku)
		List<SubjectAssignment> subjectHistory = assignmentRepo.findBySubjectId(subjectId);

		// liczymy ile roznych lat w przeszlosci kazdy instruktor prowadzil ten przedmiot
		Map<Long, Set<String>> instructorYears = new HashMap<>();
		Map<Long, Instructor> instructorsById = new HashMap<>();
		for (SubjectAssignment sa : subjectHistory) {
			if (academicYear.equals(sa.getAcademicYear())) continue; // pomijamy docelowy rok
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

			// filtr 1: tytul musi kwalifikowac do danej roli
			if (!titleQualifiesForRole(instructor.getTitle(), role)) continue;

			// filtr 2: sprawdzamy obciazenie w docelowym roku
			List<SubjectAssignment> yearLoad =
					assignmentRepo.findByInstructorIdAndAcademicYear(instructorId, academicYear);
			int totalHours = 0;
			for (SubjectAssignment sa : yearLoad) {
				if (sa.getHoursPerWeek() != null) totalHours += sa.getHoursPerWeek();
			}
			if (totalHours >= maxHoursPerWeek) continue; // przekroczony prog obciazenia

			InstructorNominationCandidate candidate = new InstructorNominationCandidate();
			candidate.setFirstName(instructor.getFirstName());
			candidate.setLastName(instructor.getLastName());
			candidate.setTitle(instructor.getTitle());
			candidate.setYearsWithSubject(instructorYears.get(instructorId).size());
			candidate.setHoursAlreadyPlanned(totalHours);
			candidates.add(candidate);
		}

		// sortujemy: najpierw najwieksze doswiadczenie, przy remisie najmniejsze obciazenie
		candidates.sort((a, b) -> {
			int cmp = Integer.compare(b.getYearsWithSubject(), a.getYearsWithSubject());
			if (cmp != 0) return cmp;
			return Integer.compare(a.getHoursAlreadyPlanned(), b.getHoursAlreadyPlanned());
		});

		return candidates;
	}

}