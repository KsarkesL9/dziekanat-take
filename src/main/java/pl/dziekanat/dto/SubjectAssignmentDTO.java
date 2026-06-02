package pl.dziekanat.dto;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import org.springframework.hateoas.RepresentationModel;

import lombok.Getter;
import pl.dziekanat.controllers.InstructorController;
import pl.dziekanat.controllers.SubjectController;
import pl.dziekanat.entities.SubjectAssignment;
import pl.dziekanat.enums.InstructorRole;

@Getter
public class SubjectAssignmentDTO extends RepresentationModel<SubjectAssignmentDTO> {

	private Long id;
	private String academicYear;
	private InstructorRole role;
	private Integer hoursPerWeek;

	public SubjectAssignmentDTO(SubjectAssignment sa) {
		this.id = sa.getId();
		this.academicYear = sa.getAcademicYear();
		this.role = sa.getRole();
		this.hoursPerWeek = sa.getHoursPerWeek();
		if (sa.getSubject() != null)
			this.add(linkTo(methodOn(SubjectController.class)
					.getSubject(sa.getSubject().getId())).withRel("subject"));
		if (sa.getInstructor() != null)
			this.add(linkTo(methodOn(InstructorController.class)
					.getInstructor(sa.getInstructor().getId())).withRel("instructor"));
	}
}
