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

import pl.dziekanat.entities.Instructor;
import pl.dziekanat.repositories.InstructorRepository;

@Controller
@RequestMapping("/instructor")
public class InstructorController {

	@Autowired
	InstructorRepository instructorRepo;

	@PostMapping
	public @ResponseBody String addInstructor(@RequestBody Instructor instructor) {
		instructor = instructorRepo.save(instructor);
		return "Added with id=" + instructor.getId();
	}

	@GetMapping("/{id}")
	public @ResponseBody Instructor getInstructor(@PathVariable Long id) {
		return instructorRepo.findById(id).get();
	}

	@GetMapping
	public @ResponseBody Iterable<Instructor> getInstructors() {
		return instructorRepo.findAll();
	}

	@GetMapping("/search")
	public @ResponseBody List<Instructor> searchInstructors(@RequestParam String lastName) {
		return instructorRepo.findByLastNameLike(lastName);
	}

	@GetMapping("/byDepartment")
	public @ResponseBody List<Instructor> getByDepartment(@RequestParam String department) {
		return instructorRepo.findByDepartment(department);
	}

	@PutMapping
	public @ResponseBody String updateInstructor(@RequestBody Instructor instructor) {
		instructor = instructorRepo.save(instructor);
		return "Updated with id=" + instructor.getId();
	}

	@DeleteMapping("/{id}")
	public @ResponseBody String deleteInstructor(@PathVariable Long id) {
		instructorRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}