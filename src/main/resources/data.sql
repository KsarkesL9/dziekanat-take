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

-- ===== Reset sekwencji (zgodnie ze stylem wykladowcy) =====
alter sequence student_seq restart with (select max(id) + 1 from student);
alter sequence subject_seq restart with (select max(id) + 1 from subject);
alter sequence grade_seq restart with (select max(id) + 1 from grade);