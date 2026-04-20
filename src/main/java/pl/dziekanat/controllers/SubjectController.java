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

import pl.dziekanat.entities.Subject;
import pl.dziekanat.repositories.SubjectRepository;

@Controller
@RequestMapping("/subject")
public class SubjectController {

	@Autowired
	SubjectRepository subjectRepo;

	@PostMapping
	public @ResponseBody String addSubject(@RequestBody Subject subject) {
		subject = subjectRepo.save(subject);
		return "Added with id=" + subject.getId();
	}

	@GetMapping("/{id}")
	public @ResponseBody Subject getSubject(@PathVariable Long id) {
		return subjectRepo.findById(id).get();
	}

	@GetMapping
	public @ResponseBody Iterable<Subject> getSubjects() {
		return subjectRepo.findAll();
	}

	@GetMapping("/search")
	public @ResponseBody List<Subject> searchSubjects(@RequestParam String name) {
		return subjectRepo.findByNameLike(name);
	}

	@PutMapping
	public @ResponseBody String updateSubject(@RequestBody Subject subject) {
		subject = subjectRepo.save(subject);
		return "Updated with id=" + subject.getId();
	}

	@DeleteMapping("/{id}")
	public @ResponseBody String deleteSubject(@PathVariable Long id) {
		subjectRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}