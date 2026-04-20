package pl.dziekanat.repositories;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import pl.dziekanat.entities.Subject;

public interface SubjectRepository extends CrudRepository<Subject, Long> {

	List<Subject> findByName(String name);

	List<Subject> findByNameLike(String name);

	List<Subject> findBySemesterNumber(Integer semesterNumber);

	List<Subject> findByEctsGreaterThan(Integer ects);
}