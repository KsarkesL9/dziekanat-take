package pl.dziekanat.dto;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import java.time.LocalDate;

import org.springframework.hateoas.RepresentationModel;

import lombok.Getter;
import pl.dziekanat.controllers.InstructorController;
import pl.dziekanat.controllers.StudentController;
import pl.dziekanat.controllers.SubjectController;
import pl.dziekanat.entities.Grade;
import pl.dziekanat.enums.GradeType;

@Getter
public class GradeDTO extends RepresentationModel<GradeDTO> {

	private Long id;
	private Double value;
	private LocalDate dateIssued;
	private GradeType gradeType;
	private String academicYear;
	private Integer attemptNumber;

	public GradeDTO(Grade g) {
		this.id = g.getId();
		this.value = g.getValue();
		this.dateIssued = g.getDateIssued();
		this.gradeType = g.getGradeType();
		this.academicYear = g.getAcademicYear();
		this.attemptNumber = g.getAttemptNumber();
		if (g.getStudent() != null)
			this.add(linkTo(methodOn(StudentController.class)
					.getStudent(g.getStudent().getId())).withRel("student"));
		if (g.getSubject() != null)
			this.add(linkTo(methodOn(SubjectController.class)
					.getSubject(g.getSubject().getId())).withRel("subject"));
		if (g.getInstructor() != null)
			this.add(linkTo(methodOn(InstructorController.class)
					.getInstructor(g.getInstructor().getId())).withRel("instructor"));
	}
}
