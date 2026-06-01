package pl.dziekanat.dto;

import java.util.List;

import pl.dziekanat.entities.Subject;

public class SemesterSettlementResult {

	private String firstName;
	private String lastName;
	private String fieldOfStudy;
	private Integer semester;
	private boolean promoted;
	private List<Subject> failedSubjects;

	public String getFirstName() { return firstName; }
	public void setFirstName(String firstName) { this.firstName = firstName; }

	public String getLastName() { return lastName; }
	public void setLastName(String lastName) { this.lastName = lastName; }

	public String getFieldOfStudy() { return fieldOfStudy; }
	public void setFieldOfStudy(String fieldOfStudy) { this.fieldOfStudy = fieldOfStudy; }

	public Integer getSemester() { return semester; }
	public void setSemester(Integer semester) { this.semester = semester; }

	public boolean isPromoted() { return promoted; }
	public void setPromoted(boolean promoted) { this.promoted = promoted; }

	public List<Subject> getFailedSubjects() { return failedSubjects; }
	public void setFailedSubjects(List<Subject> failedSubjects) { this.failedSubjects = failedSubjects; }
}