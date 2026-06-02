package pl.dziekanat.controllers;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import pl.dziekanat.dto.GradeDTO;
import pl.dziekanat.entities.Grade;
import pl.dziekanat.enums.GradeType;
import pl.dziekanat.repositories.GradeRepository;

@RestController
@RequestMapping("/grade")
public class GradeController {

	@Autowired
	GradeRepository gradeRepo;

	@PostMapping
	public String addGrade(@RequestBody Grade grade) {
		grade = gradeRepo.save(grade);
		return "Added with id=" + grade.getId();
	}

	@GetMapping("/{id}")
	public GradeDTO getGrade(@PathVariable Long id) {
		return new GradeDTO(gradeRepo.findById(id).get());
	}

	@GetMapping
	public CollectionModel<GradeDTO> getGrades() {
		List<GradeDTO> result = StreamSupport.stream(gradeRepo.findAll().spliterator(), false)
				.map(GradeDTO::new).collect(Collectors.toList());
		return CollectionModel.of(result);
	}

	@GetMapping("/byStudent")
	public List<GradeDTO> getByStudent(@RequestParam Long studentId) {
		return gradeRepo.findByStudentId(studentId).stream()
				.map(GradeDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/bySubject")
	public List<GradeDTO> getBySubject(@RequestParam Long subjectId) {
		return gradeRepo.findBySubjectId(subjectId).stream()
				.map(GradeDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byInstructor")
	public List<GradeDTO> getByInstructor(@RequestParam Long instructorId) {
		return gradeRepo.findByInstructorId(instructorId).stream()
				.map(GradeDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byType")
	public List<GradeDTO> getByType(@RequestParam GradeType gradeType) {
		return gradeRepo.findByGradeType(gradeType).stream()
				.map(GradeDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byYear")
	public List<GradeDTO> getByYear(@RequestParam String academicYear) {
		return gradeRepo.findByAcademicYear(academicYear).stream()
				.map(GradeDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/aboveValue")
	public List<GradeDTO> getAboveValue(@RequestParam Double value) {
		return gradeRepo.findByValueGreaterThan(value).stream()
				.map(GradeDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/studentSubject")
	public List<GradeDTO> getByStudentAndSubject(@RequestParam Long studentId,
			@RequestParam Long subjectId) {
		return gradeRepo.findByStudentIdAndSubjectId(studentId, subjectId).stream()
				.map(GradeDTO::new).collect(Collectors.toList());
	}

	@PutMapping
	public String updateGrade(@RequestBody Grade grade) {
		grade = gradeRepo.save(grade);
		return "Updated with id=" + grade.getId();
	}

	@DeleteMapping("/{id}")
	public String deleteGrade(@PathVariable Long id) {
		gradeRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
