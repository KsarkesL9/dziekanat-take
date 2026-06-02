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

import pl.dziekanat.dto.StudentDTO;
import pl.dziekanat.entities.Student;
import pl.dziekanat.enums.StudentStatus;
import pl.dziekanat.repositories.StudentRepository;

@RestController
@RequestMapping("/student")
public class StudentController {

	@Autowired
	StudentRepository studentRepo;

	@PostMapping
	public String addStudent(@RequestBody Student student) {
		student = studentRepo.save(student);
		return "Added with id=" + student.getId();
	}

	@GetMapping("/{id}")
	public StudentDTO getStudent(@PathVariable Long id) {
		return new StudentDTO(studentRepo.findById(id).get());
	}

	@GetMapping
	public CollectionModel<StudentDTO> getStudents() {
		List<StudentDTO> result = StreamSupport.stream(studentRepo.findAll().spliterator(), false)
				.map(StudentDTO::new).collect(Collectors.toList());
		return CollectionModel.of(result);
	}

	@GetMapping("/search")
	public List<StudentDTO> searchStudents(@RequestParam String lastName) {
		return studentRepo.findByLastNameLike(lastName).stream()
				.map(StudentDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byIndex")
	public List<StudentDTO> getByIndex(@RequestParam String indexNumber) {
		return studentRepo.findByIndexNumber(indexNumber).stream()
				.map(StudentDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byStatus")
	public List<StudentDTO> getByStatus(@RequestParam StudentStatus status) {
		return studentRepo.findByStatus(status).stream()
				.map(StudentDTO::new).collect(Collectors.toList());
	}

	@GetMapping("/byField")
	public List<StudentDTO> getByField(@RequestParam String fieldOfStudy) {
		return studentRepo.findByFieldOfStudy(fieldOfStudy).stream()
				.map(StudentDTO::new).collect(Collectors.toList());
	}

	@PutMapping
	public String updateStudent(@RequestBody Student student) {
		student = studentRepo.save(student);
		return "Updated with id=" + student.getId();
	}

	@DeleteMapping("/{id}")
	public String deleteStudent(@PathVariable Long id) {
		studentRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
