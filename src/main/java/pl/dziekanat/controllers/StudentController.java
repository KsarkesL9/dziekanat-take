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

import pl.dziekanat.entities.Student;
import pl.dziekanat.enums.StudentStatus;
import pl.dziekanat.repositories.StudentRepository;

@Controller
@RequestMapping("/student")
public class StudentController {

	@Autowired
	StudentRepository studentRepo;

	@PostMapping
	public @ResponseBody String addStudent(@RequestBody Student student) {
		student = studentRepo.save(student);
		return "Added with id=" + student.getId();
	}

	@GetMapping("/{id}")
	public @ResponseBody Student getStudent(@PathVariable Long id) {
		return studentRepo.findById(id).get();
	}

	@GetMapping
	public @ResponseBody Iterable<Student> getStudents() {
		return studentRepo.findAll();
	}

	@GetMapping("/search")
	public @ResponseBody List<Student> searchStudents(@RequestParam String lastName) {
		return studentRepo.findByLastNameLike(lastName);
	}

	@GetMapping("/byIndex")
	public @ResponseBody List<Student> getByIndex(@RequestParam String indexNumber) {
		return studentRepo.findByIndexNumber(indexNumber);
	}

	@GetMapping("/byStatus")
	public @ResponseBody List<Student> getByStatus(@RequestParam StudentStatus status) {
		return studentRepo.findByStatus(status);
	}

	@GetMapping("/byField")
	public @ResponseBody List<Student> getByField(@RequestParam String fieldOfStudy) {
		return studentRepo.findByFieldOfStudy(fieldOfStudy);
	}

	@PutMapping
	public @ResponseBody String updateStudent(@RequestBody Student student) {
		student = studentRepo.save(student);
		return "Updated with id=" + student.getId();
	}

	@DeleteMapping("/{id}")
	public @ResponseBody String deleteStudent(@PathVariable Long id) {
		studentRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
