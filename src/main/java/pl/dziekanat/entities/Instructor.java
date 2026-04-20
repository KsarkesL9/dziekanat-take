package pl.dziekanat.entities;

import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Instructor {

	@Id
	@GeneratedValue
	private Long id;

	private String firstName;

	private String lastName;

	private String email;

	private String title;

	private String department;

	@JsonIgnore
	@OneToMany(mappedBy = "instructor")
	private Set<Grade> grades = new HashSet<>();

	@JsonIgnore
	@OneToMany(mappedBy = "instructor")
	private Set<SubjectAssignment> assignments = new HashSet<>();
}