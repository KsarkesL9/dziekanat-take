package pl.dziekanat.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pl.dziekanat.enums.InstructorRole;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class SubjectAssignment {

    @Id
    @GeneratedValue
    private Long id;

    private String academicYear;

    @Enumerated(EnumType.STRING)
    private InstructorRole role;

    private Integer hoursPerWeek;

    @ManyToOne
    private Subject subject;

    @ManyToOne
    private Instructor instructor;
}