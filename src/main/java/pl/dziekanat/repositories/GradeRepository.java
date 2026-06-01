package pl.dziekanat.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;

import pl.dziekanat.entities.Grade;
import pl.dziekanat.enums.GradeType;

public interface GradeRepository extends CrudRepository<Grade, Long> {

	List<Grade> findByStudentId(Long studentId);

	List<Grade> findBySubjectId(Long subjectId);

	List<Grade> findByInstructorId(Long instructorId);

	List<Grade> findByGradeType(GradeType gradeType);

	List<Grade> findByAcademicYear(String academicYear);

	List<Grade> findByValueGreaterThan(Double value);

	List<Grade> findByValueLessThan(Double value);

	List<Grade> findByStudentIdAndSubjectId(Long studentId, Long subjectId);

	List<Grade> findByAttemptNumberGreaterThan(Integer attemptNumber);

	List<Grade> findByAcademicYearAndGradeType(String academicYear, GradeType gradeType);

	Optional<Grade> findFirstByStudentIdOrderByDateIssuedDesc(Long studentId);
}