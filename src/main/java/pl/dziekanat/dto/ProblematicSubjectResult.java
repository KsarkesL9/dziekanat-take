package pl.dziekanat.dto;

import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProblematicSubjectResult {

	private String subjectName;
	private Integer semesterNumber;
	private Integer ects;

	// lista prowadzacych w analizowanym okresie (format: tytul imie nazwisko)
	private List<String> instructors;

	// niezdawalnosc rok do roku (rok akademicki -> procent niezdawalnosci, 0-100)
	private Map<String, Double> failureRateByYear;
}