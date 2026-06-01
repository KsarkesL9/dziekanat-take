package pl.dziekanat.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class InstructorPaymentResult {

	private String firstName;
	private String lastName;
	private String title;
	private Integer hoursPerWeek;
	private Double salary;
}