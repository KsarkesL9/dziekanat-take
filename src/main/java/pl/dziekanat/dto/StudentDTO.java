package pl.dziekanat.dto;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

import java.time.LocalDate;

import org.springframework.hateoas.RepresentationModel;

import lombok.Getter;
import pl.dziekanat.controllers.GradeController;
import pl.dziekanat.entities.Student;
import pl.dziekanat.enums.StudentStatus;

@Getter
public class StudentDTO extends RepresentationModel<StudentDTO> {

	private Long id;
	private String firstName;
	private String lastName;
	private String indexNumber;
	private String email;
	private Integer semester;
	private String fieldOfStudy;
	private StudentStatus status;
	private LocalDate enrollmentDate;
	private LocalDate graduationDate;

	public StudentDTO(Student s) {
		this.id = s.getId();
		this.firstName = s.getFirstName();
		this.lastName = s.getLastName();
		this.indexNumber = s.getIndexNumber();
		this.email = s.getEmail();
		this.semester = s.getSemester();
		this.fieldOfStudy = s.getFieldOfStudy();
		this.status = s.getStatus();
		this.enrollmentDate = s.getEnrollmentDate();
		this.graduationDate = s.getGraduationDate();
		this.add(linkTo(methodOn(GradeController.class)
				.getByStudent(s.getId())).withRel("grades"));
	}
}
