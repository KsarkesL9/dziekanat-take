package pl.dziekanat.entities;

import java.util.HashSet;
import java.util.Set;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Subject {

	@Id
	@GeneratedValue
	private Long id;

	private String name;

	private Integer ects;

	private Integer semesterNumber;
	
	@JsonIgnore
	@OneToMany(mappedBy = "subject")
	private Set<Grade> grades = new HashSet<>();

	@JsonIgnore
	@OneToMany(mappedBy = "subject")
	private Set<SubjectAssignment> assignments = new HashSet<>();
}

