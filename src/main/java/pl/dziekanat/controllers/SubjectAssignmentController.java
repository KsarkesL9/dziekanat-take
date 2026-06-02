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

import pl.dziekanat.dto.SubjectAssignmentDTO;
import pl.dziekanat.entities.SubjectAssignment;
import pl.dziekanat.enums.InstructorRole;
import pl.dziekanat.repositories.SubjectAssignmentRepository;

@RestController
@RequestMapping("/assignment")
public class SubjectAssignmentController {

	@Autowired
	SubjectAssignmentRepository assignmentRepo;

	@PostMapping
	public String addAssignment(@RequestBody SubjectAssignment assignment) {
		assignment = assignmentRepo.save(assignment);
		return "Added with id=" + assignment.getId();
	}

	@GetMapping("/{id}")
	public SubjectAssignmentDTO getAssignment(@PathVariable Long id) {
		return new SubjectAssignmentDTO(assignmentRepo.findById(id).get());
	}

	@GetMapping
	public CollectionModel<SubjectAssignmentDTO> getAssignments() {
		List<SubjectAssignmentDTO> result = StreamSupport.stream(assignmentRepo.findAll().spliterator(), false)
				.map(SubjectAssignmentDTO::new).collect(Collectors.toList());
		return CollectionModel.of(result);
	}

	@GetMapping("/byYear")
	public List<SubjectAssignmentDTO> getByYear(@RequestParam String academicYear) {
		return assignmentRepo.findByAcademicYear(academicYear).stream()
				.map(SubjectAssignmentDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byRole")
	public List<SubjectAssignmentDTO> getByRole(@RequestParam InstructorRole role) {
		return assignmentRepo.findByRole(role).stream()
				.map(SubjectAssignmentDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/bySubject")
	public List<SubjectAssignmentDTO> getBySubject(@RequestParam Long subjectId) {
		return assignmentRepo.findBySubjectId(subjectId).stream()
				.map(SubjectAssignmentDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byInstructor")
	public List<SubjectAssignmentDTO> getByInstructor(@RequestParam Long instructorId) {
		return assignmentRepo.findByInstructorId(instructorId).stream()
				.map(SubjectAssignmentDTO::new).collect(Collectors.toList());
	}

	@PutMapping
	public String updateAssignment(@RequestBody SubjectAssignment assignment) {
		assignment = assignmentRepo.save(assignment);
		return "Updated with id=" + assignment.getId();
	}

	@DeleteMapping("/{id}")
	public String deleteAssignment(@PathVariable Long id) {
		assignmentRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
