package pl.dziekanat.entities;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pl.dziekanat.enums.StudentStatus;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Student {

	@Id
	@GeneratedValue
	private Long id;

	private String firstName;

	private String lastName;

	@Column(unique = true)
	private String indexNumber;

	private String email;

	private Integer semester;

	private String fieldOfStudy;

	@Enumerated(EnumType.STRING)
	private StudentStatus status;

	private LocalDate enrollmentDate;

	private LocalDate graduationDate;
	
	@JsonIgnore
	@OneToMany(mappedBy = "student")
	private Set<Grade> grades = new HashSet<>();
}
