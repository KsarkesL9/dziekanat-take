package pl.dziekanat.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InstructorNominationCandidate {

	private String firstName;
	private String lastName;
	private String title;

	// ile roznych lat w przeszlosci prowadzil ten konkretny przedmiot
	private int yearsWithSubject;

	// suma h/tydz juz zaplanowanych w docelowym roku akademickim
	private int hoursAlreadyPlanned;
}
