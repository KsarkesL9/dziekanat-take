package pl.dziekanat.dto;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import org.springframework.hateoas.RepresentationModel;

import lombok.Getter;
import pl.dziekanat.controllers.SubjectAssignmentController;
import pl.dziekanat.entities.Instructor;

@Getter
public class InstructorDTO extends RepresentationModel<InstructorDTO> {

	private Long id;
	private String firstName;
	private String lastName;
	private String email;
	private String title;
	private String department;

	public InstructorDTO(Instructor i) {
		this.id = i.getId();
		this.firstName = i.getFirstName();
		this.lastName = i.getLastName();
		this.email = i.getEmail();
		this.title = i.getTitle();
		this.department = i.getDepartment();
		this.add(linkTo(methodOn(SubjectAssignmentController.class)
				.getByInstructor(i.getId())).withRel("assignments"));
	}
}
