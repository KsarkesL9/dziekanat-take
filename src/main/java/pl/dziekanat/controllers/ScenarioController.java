package pl.dziekanat.controllers;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import pl.dziekanat.dto.GraduationResult;
import pl.dziekanat.entities.Grade;
import pl.dziekanat.entities.Student;
import pl.dziekanat.entities.Subject;
import pl.dziekanat.enums.GradeType;
import pl.dziekanat.enums.StudentStatus;
import pl.dziekanat.repositories.GradeRepository;
import pl.dziekanat.repositories.StudentRepository;

@Controller
@RequestMapping("/scenario")
public class ScenarioController {

	@Autowired
	StudentRepository studentRepo;

	@Autowired
	GradeRepository gradeRepo;

	// Scenariusz 1 Ukonczenie studiow przez studenta
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

		// dla kazdego przedmiotu zostawiamy tylko najnowsza probe
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
}