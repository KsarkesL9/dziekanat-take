package pl.dziekanat.repositories;

import org.springframework.data.repository.CrudRepository;
import pl.dziekanat.entities.Subject;

import java.util.List;

public interface SubjectRepository extends CrudRepository<Subject, Long> {

    List<Subject> findAll();

    List<Subject> findByName(String name);

    List<Subject> findByNameContaining(String name);

    List<Subject> findBySemesterNumber(Integer semesterNumber);

    List<Subject> findByEctsGreaterThan(Integer ects);
}