package pl.dziekanat.repositories;

import org.springframework.data.repository.CrudRepository;

import java.util.List;

import pl.dziekanat.entities.Instructor;

public interface InstructorRepository extends CrudRepository<Instructor, Long> {

    List<Instructor> findByLastName(String lastName);

    List<Instructor> findByLastNameLike(String lastName);

    List<Instructor> findByDepartment(String department);

    List<Instructor> findByTitle(String title);

    List<Instructor> findByFirstNameAndLastName(String firstName, String lastName);
}