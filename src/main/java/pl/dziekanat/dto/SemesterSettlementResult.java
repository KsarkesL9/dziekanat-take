package pl.dziekanat.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import pl.dziekanat.entities.Subject;

@Getter
@Setter
public class SemesterSettlementResult {

	private String firstName;
	private String lastName;
	private String fieldOfStudy;
	private Integer semester;
	private boolean promoted;
	private List<Subject> failedSubjects;
}