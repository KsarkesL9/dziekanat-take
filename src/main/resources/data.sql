-- Dane testowe dla Scenariusza 1: Ukończenie studiów przez studenta
-- POST /scenario/graduation?indexNumber={indeks}
-- Oczekiwane: 123456 -> true, 654321 -> false, 999999 -> 404

insert into subject(id, name, ects, semester_number) values (1, 'Inzynieria oprogramowania', 5, 7);
insert into subject(id, name, ects, semester_number) values (2, 'Sieci komputerowe',         6, 7);
insert into subject(id, name, ects, semester_number) values (3, 'Bazy danych',               5, 7);
-- subject 4: używany też w S4
insert into subject(id, name, ects, semester_number) values (4, 'Algebra',                   4, 1);

insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (1, 'Jan',  'Kowalski', '123456', 'jan.kowalski@example.com', 7, 'Informatyka', 'ACTIVE', '2021-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (2, 'Anna', 'Nowak',    '654321', 'anna.nowak@example.com',   7, 'Informatyka', 'ACTIVE', '2021-10-01', null);

-- Kowalski: poprawił ocenę na 4.0 -> zdaje
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (1,  2.0, '2025-02-10', 'END',  '2024/2025', 1, 1, 1); -- oblana próba 1
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (2,  4.0, '2025-03-05', 'END',  '2024/2025', 2, 1, 1); -- zdana próba 2
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (3,  3.5, '2025-02-12', 'END',  '2024/2025', 1, 1, 2);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (4,  5.0, '2025-02-15', 'END',  '2024/2025', 1, 1, 3);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (5,  2.0, '2025-01-20', 'EXAM', '2024/2025', 1, 1, 1); -- EXAM powinien być ignorowany
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (6,  2.0, '2021-02-10', 'END',  '2021/2022', 1, 1, 4); -- ocena z innego semestru

-- Nowak: obie próby poniżej 3.0 -> nie ukończy studiów
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (7,  2.0, '2025-02-10', 'END', '2024/2025', 1, 2, 1);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (8,  2.5, '2025-03-05', 'END', '2024/2025', 2, 2, 1);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (9,  4.0, '2025-02-12', 'END', '2024/2025', 1, 2, 2);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (10, 3.0, '2025-02-15', 'END', '2024/2025', 1, 2, 3);


-- Dane testowe dla Scenariusza 2: Powrót studenta z urlopu dziekańskiego
-- PUT /scenario/return-from-leave?indexNumber={indeks}&semester={nr}

insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (3, 'Piotr', 'Wisniewski', '777777', 'piotr.wisniewski@example.com', 4, 'Informatyka', 'DEAN_LEAVE', '2023-10-01', null);


-- Dane testowe dla Scenariusza 3: Rozliczenie semestru
-- POST /scenario/semester-settlement?academicYear=2024/2025

-- przedmioty dla 3. semestru
insert into subject(id, name, ects, semester_number) values (5, 'Programowanie obiektowe', 7, 3);
insert into subject(id, name, ects, semester_number) values (6, 'Matematyka dyskretna',    6, 3);
insert into subject(id, name, ects, semester_number) values (7, 'Systemy operacyjne',      5, 3);

-- studenci 3. semestru
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (4, 'Tomasz',   'Lewandowski', '300001', 't.lewandowski@example.com', 3, 'Informatyka', 'ACTIVE', '2023-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (5, 'Karolina', 'Dabrowska',   '300002', 'k.dabrowska@example.com',   3, 'Informatyka', 'ACTIVE', '2023-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (6, 'Michal',   'Zielinski',   '300003', 'm.zielinski@example.com',   3, 'Informatyka', 'ACTIVE', '2023-10-01', null);

-- Lewandowski: zaliczone wszystko -> promoted = true
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (11, 4.0, '2025-02-10', 'END', '2024/2025', 1, 4, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (12, 3.5, '2025-02-10', 'END', '2024/2025', 1, 4, 6);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (13, 5.0, '2025-02-10', 'END', '2024/2025', 1, 4, 7);

-- Dąbrowska: jedna poprawka oblana (6 ECTS) -> pozostało 24 ECTS -> promoted = true (warunkowo)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (14, 4.0, '2025-02-10', 'END', '2024/2025', 1, 5, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (15, 2.0, '2025-02-10', 'END', '2024/2025', 1, 5, 6);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (16, 3.0, '2025-02-10', 'END', '2024/2025', 1, 5, 7);

-- Zieliński: dwa oblane (13 ECTS) -> pozostało 17 ECTS -> promoted = false
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (17, 2.0, '2025-02-10', 'END', '2024/2025', 1, 6, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (18, 2.0, '2025-02-10', 'END', '2024/2025', 1, 6, 6);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (19, 4.0, '2025-02-10', 'END', '2024/2025', 1, 6, 7);


-- Dane testowe dla Scenariusza 4: Wypłata za zajęcia dla instruktora
-- GET /scenario/instructor-payment?academicYear=2024/2025

insert into instructor(id, first_name, last_name, email, title, department)
  values (1, 'Adam',   'Profesorski',  'a.profesorski@example.com',  'prof.', 'Informatyka');
insert into instructor(id, first_name, last_name, email, title, department)
  values (2, 'Barbara','Doktorska',    'b.doktorska@example.com',    'dr',    'Informatyka');
insert into instructor(id, first_name, last_name, email, title, department)
  values (3, 'Cezary', 'Magistrowski', 'c.magistrowski@example.com', 'mgr',   'Informatyka');

-- Profesorski: 2 obsady (2+3=5h/tydz)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (1, '2024/2025', 'LECTURER',            2, 1, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (2, '2024/2025', 'LECTURER',            3, 2, 1);
-- Doktorska: 1 obsada (4h/tydz)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (3, '2024/2025', 'LAB_INSTRUCTOR',       4, 3, 2);
-- Magistrowski: 1 obsada (6h/tydz)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (4, '2024/2025', 'EXERCISE_INSTRUCTOR',  6, 5, 3);
-- Obsada z innego roku (powinna być ignorowana w 2024/2025)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (5, '2023/2024', 'LECTURER',            10, 4, 2);


-- Dane testowe dla Scenariusza 5: Ranking studentów i stypendia
-- GET /scenario/scholarship-ranking?fieldOfStudy=Informatyka

-- przedmioty z 2. semestru (poprzedni dla studentów z sem. 3)
insert into subject(id, name, ects, semester_number) values (8,  'Analiza matematyczna',       8, 2);
insert into subject(id, name, ects, semester_number) values (9,  'Fizyka',                     7, 2);
insert into subject(id, name, ects, semester_number) values (10, 'Programowanie strukturalne',  8, 2);
insert into subject(id, name, ects, semester_number) values (11, 'Jezyk angielski',             7, 2);

-- student z Automatyki (do sprawdzenia filtra kierunku)
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (7, 'Ewa', 'Mazur', '300004', 'e.mazur@example.com', 3, 'Automatyka', 'ACTIVE', '2023-10-01', null);

-- Lewandowski: średnia (5*8+4.5*7+5*8+4.5*7)/30 = ~4.77
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (20, 5.0, '2024-06-20', 'END', '2023/2024', 1, 4,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (21, 4.5, '2024-06-20', 'END', '2023/2024', 1, 4,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (22, 5.0, '2024-06-20', 'END', '2023/2024', 1, 4, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (23, 4.5, '2024-06-20', 'END', '2023/2024', 1, 4, 11);

-- Dąbrowska: średnia (4*8+3.5*7+4*8+3.5*7)/30 = ~3.77
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (24, 4.0, '2024-06-20', 'END', '2023/2024', 1, 5,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (25, 3.5, '2024-06-20', 'END', '2023/2024', 1, 5,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (26, 4.0, '2024-06-20', 'END', '2023/2024', 1, 5, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (27, 3.5, '2024-06-20', 'END', '2023/2024', 1, 5, 11);

-- Zieliński: średnia (3*8+3*7+3.5*8+3*7)/30 = ~3.13
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (28, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (29, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (30, 3.5, '2024-06-20', 'END', '2023/2024', 1, 6, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (31, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6, 11);

-- Mazur (Automatyka): średnia 5.0 (nie powinna wejść do rankingu Informatyki)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (32, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (33, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (34, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (35, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 11);


-- Dane testowe dla Scenariusza 6: Identyfikacja przedmiotów problemowych
-- GET /scenario/problematic-subjects?academicYears=2021/2022,2022/2023&threshold=0.3

insert into subject(id, name, ects, semester_number) values (12, 'Statystyka',              5, 4);
insert into subject(id, name, ects, semester_number) values (13, 'Rachunek rozniczkowy',    6, 2);
insert into subject(id, name, ects, semester_number) values (14, 'Historia informatyki',    2, 1);

insert into instructor(id, first_name, last_name, email, title, department)
  values (4, 'Diana', 'Docentska', 'd.docentska@example.com', 'dr hab.', 'Informatyka');

insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (8,  'Aleksandra', 'Wojcik',    '400001', 'a.wojcik@example.com',    5, 'Informatyka', 'ACTIVE', '2022-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (9,  'Bartosz',    'Kaminski',  '400002', 'b.kaminski@example.com',  5, 'Informatyka', 'ACTIVE', '2022-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (10, 'Celina',     'Nowacka',   '400003', 'c.nowacka@example.com',   5, 'Informatyka', 'ACTIVE', '2022-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (11, 'Damian',     'Michalski', '400004', 'd.michalski@example.com', 3, 'Informatyka', 'ACTIVE', '2023-10-01', null);

-- przypisania prowadzących
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (6,  '2021/2022', 'LECTURER',           3, 12, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (7,  '2022/2023', 'LECTURER',           3, 12, 4);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (8,  '2021/2022', 'LECTURER',           4, 13, 2);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (9,  '2022/2023', 'LECTURER',           4, 13, 4);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (10, '2021/2022', 'EXERCISE_INSTRUCTOR', 2, 14, 3);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (11, '2022/2023', 'EXERCISE_INSTRUCTOR', 2, 14, 3);

-- Statystyka: 2021/2022 -> 75% oblanych, 2022/2023 -> 66.7% oblanych -> KWALIFIKUJE SIĘ
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (36, 2.0, '2022-02-10', 'END', '2021/2022', 1,  8, 12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (37, 2.0, '2022-02-10', 'END', '2021/2022', 1,  9, 12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (38, 2.0, '2022-02-10', 'END', '2021/2022', 1, 10, 12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (39, 4.0, '2022-02-10', 'END', '2021/2022', 1, 11, 12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (40, 2.0, '2023-02-10', 'END', '2022/2023', 1,  8, 12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (41, 2.0, '2023-02-10', 'END', '2022/2023', 1,  9, 12);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (42, 5.0, '2023-02-10', 'END', '2022/2023', 1, 11, 12);

-- Rachunek różniczkowy: 2021/2022 -> 75% oblanych, 2022/2023 -> 66.7% oblanych -> KWALIFIKUJE SIĘ
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (43, 2.0, '2022-06-15', 'END', '2021/2022', 1,  8, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (44, 2.0, '2022-06-15', 'END', '2021/2022', 1,  9, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (45, 2.0, '2022-06-15', 'END', '2021/2022', 1, 10, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (46, 3.5, '2022-06-15', 'END', '2021/2022', 1, 11, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (47, 2.0, '2023-06-15', 'END', '2022/2023', 1,  8, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (48, 2.0, '2023-06-15', 'END', '2022/2023', 1, 10, 13);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (49, 4.0, '2023-06-15', 'END', '2022/2023', 1, 11, 13);

-- Historia informatyki: 2021/2022 -> 100% oblanych, 2022/2023 -> 0% oblanych -> NIE KWALIFIKUJE SIĘ
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (50, 2.0, '2022-01-20', 'END', '2021/2022', 1,  8, 14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (51, 2.0, '2022-01-20', 'END', '2021/2022', 1,  9, 14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (52, 2.0, '2022-01-20', 'END', '2021/2022', 1, 10, 14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (53, 2.0, '2022-01-20', 'END', '2021/2022', 1, 11, 14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (54, 4.0, '2023-01-20', 'END', '2022/2023', 1,  8, 14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (55, 5.0, '2023-01-20', 'END', '2022/2023', 1,  9, 14);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (56, 4.5, '2023-01-20', 'END', '2022/2023', 1, 10, 14);


-- Dane testowe dla Scenariusza 7: Detekcja rezygnacji
-- GET /scenario/resignation-detection?academicYear=2024/2025

-- student Widmo: brak ocen w 2024/2025, enrollment dawno -> wykrycie rezygnacji
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (12, 'Krzysztof', 'Widmo',   '500001', 'k.widmo@example.com',   4, 'Informatyka', 'ACTIVE', '2020-10-01', null);
-- student Świeżak: niedawny zapis -> pomijamy go w raporcie
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (13, 'Natalia',   'Swiezak', '500002', 'n.swiezak@example.com', 1, 'Informatyka', 'ACTIVE', '2026-05-01', null);

-- historyczna ocena dla studenta Widmo
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (57, 3.0, '2022-06-15', 'END', '2022/2023', 1, 12, 5);


-- Dane testowe dla Scenariusza 8: Nominacja prowadzącego przedmiotu w nowym roku
-- GET /scenario/nominate-instructor

-- historia obłożeń subject 1 (Inżynieria)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (12, '2023/2024', 'LECTURER', 3, 1, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (13, '2023/2024', 'LECTURER', 3, 1, 2);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (14, '2024/2025', 'LECTURER', 3, 1, 2);

-- obciążenie na rok 2025/2026
-- Profesorski: 22h/tydz -> limit przekroczony
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (15, '2025/2026', 'LECTURER', 12, 2, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (16, '2025/2026', 'LECTURER', 10, 3, 1);
-- Doktorska: 4h/tydz -> OK
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (17, '2025/2026', 'LAB_INSTRUCTOR', 4, 5, 2);


-- Reset sekwencji ID w bazie H2
alter sequence student_seq          restart with (select max(id) + 1 from student);
alter sequence subject_seq          restart with (select max(id) + 1 from subject);
alter sequence grade_seq            restart with (select max(id) + 1 from grade);
alter sequence instructor_seq       restart with (select max(id) + 1 from instructor);
alter sequence subject_assignment_seq restart with (select max(id) + 1 from subject_assignment);