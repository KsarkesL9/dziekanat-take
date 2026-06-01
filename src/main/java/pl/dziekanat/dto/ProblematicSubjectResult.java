package pl.dziekanat.dto;

import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProblematicSubjectResult {

	// Dane przedmiotu
	private String subjectName;
	private Integer semesterNumber;
	private Integer ects;

	// Lista prowadzących w analizowanym okresie (format: "tytuł imię nazwisko")
	private List<String> instructors;

	// Niezdawalność rok do roku (rok akademicki -> % niezdawalności, 0-100)
	private Map<String, Double> failureRateByYear;
}
