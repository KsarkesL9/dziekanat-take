-- ===== Przedmioty =====
-- przedmioty z semestru 7 (ostatni semestr badanych studentow)
insert into subject(id, name, ects, semester_number) values (1, 'Inzynieria oprogramowania', 5, 7);
insert into subject(id, name, ects, semester_number) values (2, 'Sieci komputerowe', 6, 7);
insert into subject(id, name, ects, semester_number) values (3, 'Bazy danych', 5, 7);
-- przedmiot z semestru 1 - nie powinien wplywac na werdykt
insert into subject(id, name, ects, semester_number) values (4, 'Algebra', 4, 1);

-- ===== Studenci =====
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (1, 'Jan', 'Kowalski', '123456', 'jan.kowalski@example.com', 7, 'Informatyka', 'ACTIVE', '2021-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (2, 'Anna', 'Nowak', '654321', 'anna.nowak@example.com', 7, 'Informatyka', 'ACTIVE', '2021-10-01', null);

-- ===== Oceny studenta 1 (Kowalski) - POWINIEN moc ukonczyc =====
-- Inzynieria oprogramowania: poprawka - proba 1 oblana, proba 2 zdana (liczy sie proba 2)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (1, 2.0, '2025-02-10', 'END', '2024/2025', 1, 1, 1);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (2, 4.0, '2025-03-05', 'END', '2024/2025', 2, 1, 1);
-- Sieci komputerowe: zdana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (3, 3.5, '2025-02-12', 'END', '2024/2025', 1, 1, 2);
-- Bazy danych: zdana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (4, 5.0, '2025-02-15', 'END', '2024/2025', 1, 1, 3);
-- ocena typu EXAM (nie END) - powinna byc ignorowana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (5, 2.0, '2025-01-20', 'EXAM', '2024/2025', 1, 1, 1);
-- ocena END z semestru 1 - inny semestr, powinna byc ignorowana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (6, 2.0, '2021-02-10', 'END', '2021/2022', 1, 1, 4);
  -- student na urlopie dziekanskim - do scenariusza 2
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (3, 'Piotr', 'Wisniewski', '777777', 'piotr.wisniewski@example.com', 4, 'Informatyka', 'DEAN_LEAVE', '2023-10-01', null);

-- ===== Oceny studenta 2 (Nowak) - NIE powinien moc ukonczyc =====
-- Inzynieria oprogramowania: poprawka - obie proby oblane (liczy sie proba 2 = 2.5)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (7, 2.0, '2025-02-10', 'END', '2024/2025', 1, 2, 1);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (8, 2.5, '2025-03-05', 'END', '2024/2025', 2, 2, 1);
-- Sieci komputerowe: zdana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (9, 4.0, '2025-02-12', 'END', '2024/2025', 1, 2, 2);
-- Bazy danych: zdana (dokladnie 3.0 - granica zaliczenia)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (10, 3.0, '2025-02-15', 'END', '2024/2025', 1, 2, 3);
  
  -- przedmioty semestru 3 (do scenariusza 3)
insert into subject(id, name, ects, semester_number) values (5, 'Programowanie obiektowe', 7, 3);
insert into subject(id, name, ects, semester_number) values (6, 'Matematyka dyskretna', 6, 3);
insert into subject(id, name, ects, semester_number) values (7, 'Systemy operacyjne', 5, 3);

-- studenci aktywni z semestru 3
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (4, 'Tomasz', 'Lewandowski', '300001', 't.lewandowski@example.com', 3, 'Informatyka', 'ACTIVE', '2023-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (5, 'Karolina', 'Dabrowska', '300002', 'k.dabrowska@example.com', 3, 'Informatyka', 'ACTIVE', '2023-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (6, 'Michal', 'Zielinski', '300003', 'm.zielinski@example.com', 3, 'Informatyka', 'ACTIVE', '2023-10-01', null);

-- Student 4: wszystko zdane -> remaining 30 -> promocja do 4
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (11, 4.0, '2025-02-10', 'END', '2024/2025', 1, 4, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (12, 3.5, '2025-02-10', 'END', '2024/2025', 1, 4, 6);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (13, 5.0, '2025-02-10', 'END', '2024/2025', 1, 4, 7);

-- Student 5: oblana Matematyka dyskretna (6 ECTS) -> remaining 24 -> promocja warunkowa do 4
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (14, 4.0, '2025-02-10', 'END', '2024/2025', 1, 5, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (15, 2.0, '2025-02-10', 'END', '2024/2025', 1, 5, 6);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (16, 3.0, '2025-02-10', 'END', '2024/2025', 1, 5, 7);

-- Student 6: oblane PO (7) + Matematyka (6) = 13 ECTS -> remaining 17 -> brak promocji, zostaje na 3
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (17, 2.0, '2025-02-10', 'END', '2024/2025', 1, 6, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (18, 2.0, '2025-02-10', 'END', '2024/2025', 1, 6, 6);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (19, 4.0, '2025-02-10', 'END', '2024/2025', 1, 6, 7);

-- === Scenariusz 4: instruktorzy i obsady ===
insert into instructor(id, first_name, last_name, email, title, department)
  values (1, 'Adam', 'Profesorski', 'a.profesorski@example.com', 'prof.', 'Informatyka');
insert into instructor(id, first_name, last_name, email, title, department)
  values (2, 'Barbara', 'Doktorska', 'b.doktorska@example.com', 'dr', 'Informatyka');
insert into instructor(id, first_name, last_name, email, title, department)
  values (3, 'Cezary', 'Magistrowski', 'c.magistrowski@example.com', 'mgr', 'Informatyka');

-- obsady w roku 2024/2025
-- prof. Profesorski: 2 obsady -> suma 5 h/tydz -> 5*4*150 = 3000
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (1, '2024/2025', 'LECTURER', 2, 1, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (2, '2024/2025', 'LECTURER', 3, 2, 1);
-- dr Doktorska: 1 obsada -> 4 h/tydz -> 4*4*100 = 1600
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (3, '2024/2025', 'LAB_INSTRUCTOR', 4, 3, 2);
-- mgr Magistrowski: 1 obsada -> 6 h/tydz -> 6*4*80 = 1920
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (4, '2024/2025', 'EXERCISE_INSTRUCTOR', 6, 5, 3);
-- obsada dr Doktorskiej w INNYM roku - nie powinna liczyc sie do 2024/2025
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (5, '2023/2024', 'LECTURER', 10, 4, 2);
  
  -- === Scenariusz 5: przedmioty semestru 2 i oceny ===
insert into subject(id, name, ects, semester_number) values (8, 'Analiza matematyczna', 8, 2);
insert into subject(id, name, ects, semester_number) values (9, 'Fizyka', 7, 2);
insert into subject(id, name, ects, semester_number) values (10, 'Programowanie strukturalne', 8, 2);
insert into subject(id, name, ects, semester_number) values (11, 'Jezyk angielski', 7, 2);

-- student z innego kierunku - nie powinien byc w rankingu Informatyki
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (7, 'Ewa', 'Mazur', '300004', 'e.mazur@example.com', 3, 'Automatyka', 'ACTIVE', '2023-10-01', null);

-- oceny END z semestru 2 (poprzedni semestr dla studentow z semestru 3)
-- Lewandowski (4) ~4.77
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (20, 5.0, '2024-06-20', 'END', '2023/2024', 1, 4, 8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (21, 4.5, '2024-06-20', 'END', '2023/2024', 1, 4, 9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (22, 5.0, '2024-06-20', 'END', '2023/2024', 1, 4, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (23, 4.5, '2024-06-20', 'END', '2023/2024', 1, 4, 11);
-- Dabrowska (5) ~3.77
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (24, 4.0, '2024-06-20', 'END', '2023/2024', 1, 5, 8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (25, 3.5, '2024-06-20', 'END', '2023/2024', 1, 5, 9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (26, 4.0, '2024-06-20', 'END', '2023/2024', 1, 5, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (27, 3.5, '2024-06-20', 'END', '2023/2024', 1, 5, 11);
-- Zielinski (6) ~3.13
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (28, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6, 8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (29, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6, 9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (30, 3.5, '2024-06-20', 'END', '2023/2024', 1, 6, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (31, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6, 11);
-- Mazur (7, Automatyka) najwyzsza srednia, ale inny kierunek
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (32, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (33, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (34, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (35, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 11);

-- ===== Reset sekwencji (zgodnie ze stylem wykladowcy) =====
alter sequence student_seq restart with (select max(id) + 1 from student);
alter sequence subject_seq restart with (select max(id) + 1 from subject);
alter sequence grade_seq restart with (select max(id) + 1 from grade);
alter sequence instructor_seq restart with (select max(id) + 1 from instructor);
alter sequence subject_assignment_seq restart with (select max(id) + 1 from subject_assignment);