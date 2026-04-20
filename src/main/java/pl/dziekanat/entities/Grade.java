package pl.dziekanat.entities;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pl.dziekanat.enums.GradeType;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Grade {

	@Id
	@GeneratedValue
	private Long id;
	// okazuje sie ze value to slowo kluczowe w szbd trzeba zmienic nazwe kolumny
	@Column(name = "grade_value")
	private Double value;

	private LocalDate dateIssued;

	@Enumerated(EnumType.STRING)
	private GradeType gradeType;

	private String academicYear;

	private Integer attemptNumber;

	@ManyToOne
	private Student student;

	@ManyToOne
	private Subject subject;

	@ManyToOne
	private Instructor instructor;
}
