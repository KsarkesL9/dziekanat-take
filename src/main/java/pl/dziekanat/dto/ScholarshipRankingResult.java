package pl.dziekanat.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ScholarshipRankingResult {

	private String firstName;
	private String lastName;
	private String indexNumber;
	private String fieldOfStudy;
	private Double weightedAverage;
}