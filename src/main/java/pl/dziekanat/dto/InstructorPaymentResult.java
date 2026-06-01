package pl.dziekanat.dto;

public class InstructorPaymentResult {

	private String firstName;
	private String lastName;
	private String title;
	private Integer hoursPerWeek;
	private Double salary;

	public String getFirstName() { return firstName; }
	public void setFirstName(String firstName) { this.firstName = firstName; }

	public String getLastName() { return lastName; }
	public void setLastName(String lastName) { this.lastName = lastName; }

	public String getTitle() { return title; }
	public void setTitle(String title) { this.title = title; }

	public Integer getHoursPerWeek() { return hoursPerWeek; }
	public void setHoursPerWeek(Integer hoursPerWeek) { this.hoursPerWeek = hoursPerWeek; }

	public Double getSalary() { return salary; }
	public void setSalary(Double salary) { this.salary = salary; }
}