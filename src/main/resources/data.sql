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

-- === Scenariusz 6: Identyfikacja przedmiotow problemowych ===
-- Lata analizy: 2021/2022 i 2022/2023, prog niezdawalnosci: 0.3 (30%)
-- Oczekiwany wynik: przedmioty 12 i 13 POWINNY sie pojawic, przedmiot 14 NIE.

-- Nowe przedmioty
insert into subject(id, name, ects, semester_number) values (12, 'Statystyka', 5, 4);
insert into subject(id, name, ects, semester_number) values (13, 'Rachunek rozniczkowy', 6, 2);
insert into subject(id, name, ects, semester_number) values (14, 'Historia informatyki', 2, 1);

-- Nowy prowadzacy
insert into instructor(id, first_name, last_name, email, title, department)
  values (4, 'Diana', 'Docentska', 'd.docentska@example.com', 'dr hab.', 'Informatyka');

-- Nowi studenci
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (8,  'Aleksandra', 'Wojcik',     '400001', 'a.wojcik@example.com',     5, 'Informatyka', 'ACTIVE', '2022-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (9,  'Bartosz',    'Kaminski',   '400002', 'b.kaminski@example.com',   5, 'Informatyka', 'ACTIVE', '2022-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (10, 'Celina',     'Nowacka',    '400003', 'c.nowacka@example.com',    5, 'Informatyka', 'ACTIVE', '2022-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (11, 'Damian',     'Michalski',  '400004', 'd.michalski@example.com',  3, 'Informatyka', 'ACTIVE', '2023-10-01', null);

-- Obsady dla scenariusza 6
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (6,  '2021/2022', 'LECTURER',          3, 12, 1); -- Statystyka - prof. Profesorski
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (7,  '2022/2023', 'LECTURER',          3, 12, 4); -- Statystyka - dr hab. Docentska
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (8,  '2021/2022', 'LECTURER',          4, 13, 2); -- Rachunek rozniczkowy - dr Doktorska
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (9,  '2022/2023', 'LECTURER',          4, 13, 4); -- Rachunek rozniczkowy - dr hab. Docentska
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (10, '2021/2022', 'EXERCISE_INSTRUCTOR', 2, 14, 3); -- Historia informatyki - mgr Magistrowski
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (11, '2022/2023', 'EXERCISE_INSTRUCTOR', 2, 14, 3); -- Historia informatyki - mgr Magistrowski

-- Oceny "Statystyka" (id=12) - PRZEDMIOT PROBLEMOWY
-- 2021/2022, attempt=1: 3 oblane / 4 ogolnie = 75%
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (36, 2.0, '2022-02-10', 'END', '2021/2022', 1, 8,  12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (37, 2.0, '2022-02-10', 'END', '2021/2022', 1, 9,  12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (38, 2.0, '2022-02-10', 'END', '2021/2022', 1, 10, 12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (39, 4.0, '2022-02-10', 'END', '2021/2022', 1, 11, 12);
-- 2022/2023, attempt=1: 2 oblane / 3 = 66.7%
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (40, 2.0, '2023-02-10', 'END', '2022/2023', 1, 8,  12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (41, 2.0, '2023-02-10', 'END', '2022/2023', 1, 9,  12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (42, 5.0, '2023-02-10', 'END', '2022/2023', 1, 11, 12);

-- Oceny "Rachunek rozniczkowy" (id=13) - PRZEDMIOT PROBLEMOWY
-- 2021/2022, attempt=1: 3 oblane / 4 = 75%
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (43, 2.0, '2022-06-15', 'END', '2021/2022', 1, 8,  13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (44, 2.0, '2022-06-15', 'END', '2021/2022', 1, 9,  13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (45, 2.0, '2022-06-15', 'END', '2021/2022', 1, 10, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (46, 3.5, '2022-06-15', 'END', '2021/2022', 1, 11, 13);
-- 2022/2023, attempt=1: 2 oblane / 3 = 66.7%
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (47, 2.0, '2023-06-15', 'END', '2022/2023', 1, 8,  13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (48, 2.0, '2023-06-15', 'END', '2022/2023', 1, 10, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (49, 4.0, '2023-06-15', 'END', '2022/2023', 1, 11, 13);

-- Oceny "Historia informatyki" (id=14) - NIE PROBLEMOWY
-- 2021/2022, attempt=1: 4 oblane / 4 = 100% (przekracza prog)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (50, 2.0, '2022-01-20', 'END', '2021/2022', 1, 8,  14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (51, 2.0, '2022-01-20', 'END', '2021/2022', 1, 9,  14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (52, 2.0, '2022-01-20', 'END', '2021/2022', 1, 10, 14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (53, 2.0, '2022-01-20', 'END', '2021/2022', 1, 11, 14);
-- 2022/2023, attempt=1: 0 oblane / 3 = 0% (nie przekracza progu -> przedmiot odpada)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (54, 4.0, '2023-01-20', 'END', '2022/2023', 1, 8,  14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (55, 5.0, '2023-01-20', 'END', '2022/2023', 1, 9,  14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id) values (56, 4.5, '2023-01-20', 'END', '2022/2023', 1, 10, 14);

-- === Scenariusz 7: Detekcja rezygnacji ===
-- Rok zapytania: 2024/2025
-- Oczekiwane wyniki: studenci ACTIVE bez ocen w 2024/2025 i z enrollment > 3 mies. temu:
--   - student 12 (Krzysztof Widmo) POWINIEN sie pojawic - ostatnia ocena: 2022-06-15
--   - student 13 (Natalia Swiezak) NIE POWINNA sie pojawic - zapisana 2026-05-01 (< 3 mies.)
--   (oraz studenci 4-11 z wczesniejszych scenariuszy, ktorzy tez nie maja ocen w 2024/2025)

-- Student "duch" - ACTIVE, brak ocen w 2024/2025, dawno zapisany, ma oceny historyczne
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (12, 'Krzysztof', 'Widmo', '500001', 'k.widmo@example.com', 4, 'Informatyka', 'ACTIVE', '2020-10-01', null);

-- Student swiezo zapisany - ACTIVE, brak ocen w 2024/2025, ALE enrolled < 3 miesiace temu
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (13, 'Natalia', 'Swiezak', '500002', 'n.swiezak@example.com', 1, 'Informatyka', 'ACTIVE', '2026-05-01', null);

-- Ocena historyczna dla studenta 12 (Widmo) - z roku 2022/2023, sluzy jako lastGradeDate
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (57, 3.0, '2022-06-15', 'END', '2022/2023', 1, 12, 5);

-- === Scenariusz 8: Nominacja prowadzacego w nowym roku akademickim ===
-- Zapytanie: subjectId=1, role=LECTURER, academicYear=2025/2026, maxHoursPerWeek=20
-- Oczekiwany wynik:
--   - dr Doktorska (inst. 2) POWINNA sie pojawic: 2 lata doswiadczenia z subj.1, 4h w 2025/2026
--   - prof. Profesorski (inst. 1) NIE POWINIEN: 1 rok doswiadczenia z subj.1, ale 22h w 2025/2026 (przeciazony)
--   - dr hab. Docentska (inst. 4) NIE POWINNA: brak doswiadczenia z subj.1
--   - mgr Magistrowski (inst. 3) NIE POWINIEN: tytul nie kwalifikuje do LECTURER

-- Przeszle obsady subject=1 (Inzynieria oprogramowania) jako historia doswiadczen
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (12, '2023/2024', 'LECTURER', 3, 1, 1); -- prof. Profesorski: 1 rok z subj.1
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (13, '2023/2024', 'LECTURER', 3, 1, 2); -- dr Doktorska: rok 1 z subj.1
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (14, '2024/2025', 'LECTURER', 3, 1, 2); -- dr Doktorska: rok 2 z subj.1 (wyzsze doswiadczenie)

-- Obciazenie prowadzacych w docelowym roku 2025/2026
-- prof. Profesorski: 12 + 10 = 22h/tyg -> PRZECIAZONY (>= 20)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (15, '2025/2026', 'LECTURER', 12, 2, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (16, '2025/2026', 'LECTURER', 10, 3, 1);
-- dr Doktorska: tylko 4h/tyg -> NIE przeciazony
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (17, '2025/2026', 'LAB_INSTRUCTOR', 4, 5, 2);

-- ===== Reset sekwencji (zgodnie ze stylem wykladowcy) =====
alter sequence student_seq restart with (select max(id) + 1 from student);
alter sequence subject_seq restart with (select max(id) + 1 from subject);
alter sequence grade_seq restart with (select max(id) + 1 from grade);
alter sequence instructor_seq restart with (select max(id) + 1 from instructor);
alter sequence subject_assignment_seq restart with (select max(id) + 1 from subject_assignment);