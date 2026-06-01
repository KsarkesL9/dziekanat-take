package pl.dziekanat.dto;

public class ScholarshipRankingResult {

	private String firstName;
	private String lastName;
	private String indexNumber;
	private String fieldOfStudy;
	private Double weightedAverage;

	public String getFirstName() { return firstName; }
	public void setFirstName(String firstName) { this.firstName = firstName; }

	public String getLastName() { return lastName; }
	public void setLastName(String lastName) { this.lastName = lastName; }

	public String getIndexNumber() { return indexNumber; }
	public void setIndexNumber(String indexNumber) { this.indexNumber = indexNumber; }

	public String getFieldOfStudy() { return fieldOfStudy; }
	public void setFieldOfStudy(String fieldOfStudy) { this.fieldOfStudy = fieldOfStudy; }

	public Double getWeightedAverage() { return weightedAverage; }
	public void setWeightedAverage(Double weightedAverage) { this.weightedAverage = weightedAverage; }
}