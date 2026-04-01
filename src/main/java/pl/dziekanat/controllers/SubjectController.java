package pl.dziekanat.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import pl.dziekanat.entities.Subject;
import pl.dziekanat.repositories.SubjectRepository;

import java.util.List;

@Controller
@RequestMapping("/subject")
public class SubjectController {

    @Autowired
    SubjectRepository subjectRepo;

    // POST /subject - tworzy nowy przedmiot
    @PostMapping
    public @ResponseBody String addSubject(@RequestBody Subject subject) {
        subject = subjectRepo.save(subject);
        return "Added with id=" + subject.getId();
    }

    // GET /subject/{id} - zwraca przedmiot o podanym id
    @GetMapping("/{id}")
    public @ResponseBody Subject getSubject(@PathVariable Long id) {
        return subjectRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Subject not found with id=" + id));
    }

    // GET /subject - zwraca wszystkie przedmioty
    @GetMapping
    public @ResponseBody Iterable<Subject> getAllSubjects() {
        return subjectRepo.findAll();
    }

    // GET /subject/search?name=Algebra - wyszukiwanie po nazwie
    @GetMapping("/search")
    public @ResponseBody List<Subject> searchSubjects(@RequestParam String name) {
        return subjectRepo.findByNameContaining(name);
    }

    // GET /subject/semester/3 - przedmioty na danym semestrze
    @GetMapping("/semester/{semester}")
    public @ResponseBody List<Subject> getBySemester(@PathVariable Integer semester) {
        return subjectRepo.findBySemesterNumber(semester);
    }

    // PUT /subject - aktualizuje przedmiot 
    @PutMapping
    public @ResponseBody String updateSubject(@RequestBody Subject subject) {
        subject = subjectRepo.save(subject);
        return "Updated id=" + subject.getId();
    }

    // DELETE /subject/{id} - usuwa przedmiot
    @DeleteMapping("/{id}")
    public @ResponseBody String deleteSubject(@PathVariable Long id) {
        subjectRepo.deleteById(id);
        return "Deleted id=" + id;
    }
}