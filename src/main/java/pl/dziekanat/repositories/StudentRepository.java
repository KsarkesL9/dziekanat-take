package pl.dziekanat.repositories;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

import pl.dziekanat.entities.Student;
import pl.dziekanat.enums.StudentStatus;

public interface StudentRepository extends CrudRepository<Student, Long> {

    List<Student> findByLastName(String lastName);

    List<Student> findByLastNameLike(String lastName);

    List<Student> findByIndexNumber(String indexNumber);

    List<Student> findByFieldOfStudy(String fieldOfStudy);

    List<Student> findByStatus(StudentStatus status);

    List<Student> findBySemester(Integer semester);

    List<Student> findBySemesterGreaterThan(Integer semester);
}