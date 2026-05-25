package pl.dziekanat.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import pl.dziekanat.entities.Subject;

@Getter
@Setter
public class GraduationResult {

	private boolean canGraduate;

	private String message;

	private List<Subject> failedSubjects;
}