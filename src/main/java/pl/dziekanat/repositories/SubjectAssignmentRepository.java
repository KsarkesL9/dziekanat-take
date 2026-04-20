package pl.dziekanat.repositories;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

import pl.dziekanat.entities.SubjectAssignment;
import pl.dziekanat.enums.InstructorRole;

public interface SubjectAssignmentRepository extends CrudRepository<SubjectAssignment, Long> {

	List<SubjectAssignment> findByAcademicYear(String academicYear);

	List<SubjectAssignment> findByRole(InstructorRole role);

	List<SubjectAssignment> findBySubjectId(Long subjectId);

	List<SubjectAssignment> findByInstructorId(Long instructorId);

	List<SubjectAssignment> findByInstructorIdAndAcademicYear(Long instructorId, String academicYear);
}