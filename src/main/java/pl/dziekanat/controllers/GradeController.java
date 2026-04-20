package pl.dziekanat.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import pl.dziekanat.entities.Grade;
import pl.dziekanat.enums.GradeType;
import pl.dziekanat.repositories.GradeRepository;

@Controller
@RequestMapping("/grade")
public class GradeController {

	@Autowired
	GradeRepository gradeRepo;

	@PostMapping
	public @ResponseBody String addGrade(@RequestBody Grade grade) {
		grade = gradeRepo.save(grade);
		return "Added with id=" + grade.getId();
	}

	@GetMapping("/{id}")
	public @ResponseBody Grade getGrade(@PathVariable Long id) {
		return gradeRepo.findById(id).get();
	}

	@GetMapping
	public @ResponseBody Iterable<Grade> getGrades() {
		return gradeRepo.findAll();
	}

	@GetMapping("/byStudent")
	public @ResponseBody List<Grade> getByStudent(@RequestParam Long studentId) {
		return gradeRepo.findByStudentId(studentId);
	}

	@GetMapping("/bySubject")
	public @ResponseBody List<Grade> getBySubject(@RequestParam Long subjectId) {
		return gradeRepo.findBySubjectId(subjectId);
	}

	@GetMapping("/byInstructor")
	public @ResponseBody List<Grade> getByInstructor(@RequestParam Long instructorId) {
		return gradeRepo.findByInstructorId(instructorId);
	}

	@GetMapping("/byType")
	public @ResponseBody List<Grade> getByType(@RequestParam GradeType gradeType) {
		return gradeRepo.findByGradeType(gradeType);
	}

	@GetMapping("/byYear")
	public @ResponseBody List<Grade> getByYear(@RequestParam String academicYear) {
		return gradeRepo.findByAcademicYear(academicYear);
	}

	@GetMapping("/aboveValue")
	public @ResponseBody List<Grade> getAboveValue(@RequestParam Double value) {
		return gradeRepo.findByValueGreaterThan(value);
	}

	@GetMapping("/studentSubject")
	public @ResponseBody List<Grade> getByStudentAndSubject(@RequestParam Long studentId,
			@RequestParam Long subjectId) {
		return gradeRepo.findByStudentIdAndSubjectId(studentId, subjectId);
	}

	@PutMapping
	public @ResponseBody String updateGrade(@RequestBody Grade grade) {
		grade = gradeRepo.save(grade);
		return "Updated with id=" + grade.getId();
	}

	@DeleteMapping("/{id}")
	public @ResponseBody String deleteGrade(@PathVariable Long id) {
		gradeRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
