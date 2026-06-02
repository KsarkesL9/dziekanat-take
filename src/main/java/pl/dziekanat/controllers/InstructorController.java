package pl.dziekanat.controllers;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import pl.dziekanat.dto.InstructorDTO;
import pl.dziekanat.entities.Instructor;
import pl.dziekanat.repositories.InstructorRepository;

@RestController
@RequestMapping("/instructor")
public class InstructorController {

	@Autowired
	InstructorRepository instructorRepo;

	@PostMapping
	public String addInstructor(@RequestBody Instructor instructor) {
		instructor = instructorRepo.save(instructor);
		return "Added with id=" + instructor.getId();
	}

	@GetMapping("/{id}")
	public InstructorDTO getInstructor(@PathVariable Long id) {
		return new InstructorDTO(instructorRepo.findById(id).get());
	}

	@GetMapping
	public CollectionModel<InstructorDTO> getInstructors() {
		List<InstructorDTO> result = StreamSupport.stream(instructorRepo.findAll().spliterator(), false)
				.map(InstructorDTO::new).collect(Collectors.toList());
		return CollectionModel.of(result);
	}

	@GetMapping("/search")
	public List<InstructorDTO> searchInstructors(@RequestParam String lastName) {
		return instructorRepo.findByLastNameLike(lastName).stream()
				.map(InstructorDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byDepartment")
	public List<InstructorDTO> getByDepartment(@RequestParam String department) {
		return instructorRepo.findByDepartment(department).stream()
				.map(InstructorDTO::new).collect(Collectors.toList());
	}

	@PutMapping
	public String updateInstructor(@RequestBody Instructor instructor) {
		instructor = instructorRepo.save(instructor);
		return "Updated with id=" + instructor.getId();
	}

	@DeleteMapping("/{id}")
	public String deleteInstructor(@PathVariable Long id) {
		instructorRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
