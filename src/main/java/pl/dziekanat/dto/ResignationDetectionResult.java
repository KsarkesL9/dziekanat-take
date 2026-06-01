package pl.dziekanat.dto;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ResignationDetectionResult {

	private String indexNumber;
	private String firstName;
	private String lastName;
	private String email;
	private Integer semester;

	// null jesli student nie ma zadnej oceny w historii
	private LocalDate lastGradeDate;
}
