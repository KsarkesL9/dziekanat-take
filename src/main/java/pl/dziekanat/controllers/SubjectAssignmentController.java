package pl.dziekanat.controllers;

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

import java.util.List;

import pl.dziekanat.entities.SubjectAssignment;
import pl.dziekanat.enums.InstructorRole;
import pl.dziekanat.repositories.SubjectAssignmentRepository;

@Controller
@RequestMapping("/assignment")
public class SubjectAssignmentController {

	@Autowired
	SubjectAssignmentRepository assignmentRepo;

	@PostMapping
	public @ResponseBody String addAssignment(@RequestBody SubjectAssignment assignment) {
		assignment = assignmentRepo.save(assignment);
		return "Added with id=" + assignment.getId();
	}

	@GetMapping("/{id}")
	public @ResponseBody SubjectAssignment getAssignment(@PathVariable Long id) {
		return assignmentRepo.findById(id).get();
	}

	@GetMapping
	public @ResponseBody Iterable<SubjectAssignment> getAssignments() {
		return assignmentRepo.findAll();
	}

	@GetMapping("/byYear")
	public @ResponseBody List<SubjectAssignment> getByYear(@RequestParam String academicYear) {
		return assignmentRepo.findByAcademicYear(academicYear);
	}

	@GetMapping("/byRole")
	public @ResponseBody List<SubjectAssignment> getByRole(@RequestParam InstructorRole role) {
		return assignmentRepo.findByRole(role);
	}

	@GetMapping("/bySubject")
	public @ResponseBody List<SubjectAssignment> getBySubject(@RequestParam Long subjectId) {
		return assignmentRepo.findBySubjectId(subjectId);
	}

	@GetMapping("/byInstructor")
	public @ResponseBody List<SubjectAssignment> getByInstructor(@RequestParam Long instructorId) {
		return assignmentRepo.findByInstructorId(instructorId);
	}

	@PutMapping
	public @ResponseBody String updateAssignment(@RequestBody SubjectAssignment assignment) {
		assignment = assignmentRepo.save(assignment);
		return "Updated with id=" + assignment.getId();
	}

	@DeleteMapping("/{id}")
	public @ResponseBody String deleteAssignment(@PathVariable Long id) {
		assignmentRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
