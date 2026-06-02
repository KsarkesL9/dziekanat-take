package pl.dziekanat.dto;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import org.springframework.hateoas.RepresentationModel;

import lombok.Getter;
import pl.dziekanat.controllers.SubjectAssignmentController;
import pl.dziekanat.entities.Subject;

@Getter
public class SubjectDTO extends RepresentationModel<SubjectDTO> {

	private Long id;
	private String name;
	private Integer ects;
	private Integer semesterNumber;

	public SubjectDTO(Subject s) {
		this.id = s.getId();
		this.name = s.getName();
		this.ects = s.getEcts();
		this.semesterNumber = s.getSemesterNumber();
		this.add(linkTo(methodOn(SubjectAssignmentController.class)
				.getBySubject(s.getId())).withRel("assignments"));
	}
}
