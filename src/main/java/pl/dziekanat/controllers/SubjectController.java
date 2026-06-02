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

import pl.dziekanat.dto.SubjectDTO;
import pl.dziekanat.entities.Subject;
import pl.dziekanat.repositories.SubjectRepository;

@RestController
@RequestMapping("/subject")
public class SubjectController {

	@Autowired
	SubjectRepository subjectRepo;

	@PostMapping
	public String addSubject(@RequestBody Subject subject) {
		subject = subjectRepo.save(subject);
		return "Added with id=" + subject.getId();
	}

	@GetMapping("/{id}")
	public SubjectDTO getSubject(@PathVariable Long id) {
		return new SubjectDTO(subjectRepo.findById(id).get());
	}

	@GetMapping
	public CollectionModel<SubjectDTO> getSubjects() {
		List<SubjectDTO> result = StreamSupport.stream(subjectRepo.findAll().spliterator(), false)
				.map(SubjectDTO::new).collect(Collectors.toList());
		return CollectionModel.of(result);
	}

	@GetMapping("/search")
	public List<SubjectDTO> searchSubjects(@RequestParam String name) {
		return subjectRepo.findByNameLike(name).stream()
				.map(SubjectDTO::new).collect(Collectors.toList());
	}

	@PutMapping
	public String updateSubject(@RequestBody Subject subject) {
		subject = subjectRepo.save(subject);
		return "Updated with id=" + subject.getId();
	}

	@DeleteMapping("/{id}")
	public String deleteSubject(@PathVariable Long id) {
		subjectRepo.deleteById(id);
		return "Deleted id=" + id;
	}
}
