-- ============================================================================
-- S1: Ukonczenie studiow przez studenta
-- Metoda + URL: POST /scenario/graduation?indexNumber={indeks}
-- Oczekiwany wynik:
--   indexNumber=123456  canGraduate=true,  failedSubjects=[],              student GRADUATED
--   indexNumber=654321  canGraduate=false, failedSubjects=[Inzynieria oprogramowania]
--   indexNumber=999999  404 Not Found
-- Sprawdza: filtr gradeType=END, filtr semestru (rozny sem ignorowany),
--           logike poprawek (proba 1 oblana + proba 2 zdana = liczy sie proba 2)
-- Uwaga: subjects 1-4 i students 1-2 uzywane rowniez w S3, S4, S5, S7
-- ============================================================================

insert into subject(id, name, ects, semester_number) values (1, 'Inzynieria oprogramowania', 5, 7);
insert into subject(id, name, ects, semester_number) values (2, 'Sieci komputerowe',         6, 7);
insert into subject(id, name, ects, semester_number) values (3, 'Bazy danych',               5, 7);
-- subject 4: uzywany w S1 (ocena ignorowana - inny semestr) i S4 (obsada ignorowana - inny rok)
insert into subject(id, name, ects, semester_number) values (4, 'Algebra',                   4, 1);

insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (1, 'Jan',  'Kowalski', '123456', 'jan.kowalski@example.com', 7, 'Informatyka', 'ACTIVE', '2021-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (2, 'Anna', 'Nowak',    '654321', 'anna.nowak@example.com',   7, 'Informatyka', 'ACTIVE', '2021-10-01', null);

-- Kowalski: proba 1 oblana, proba 2 zdana -> liczy sie proba 2 -> canGraduate=true
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (1,  2.0, '2025-02-10', 'END',  '2024/2025', 1, 1, 1); -- Inzynieria proba 1: oblana (2.0) - ignorowana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (2,  4.0, '2025-03-05', 'END',  '2024/2025', 2, 1, 1); -- Inzynieria proba 2: zdana  (4.0) - liczy sie
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (3,  3.5, '2025-02-12', 'END',  '2024/2025', 1, 1, 2); -- Sieci: zdane
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (4,  5.0, '2025-02-15', 'END',  '2024/2025', 1, 1, 3); -- Bazy: zdane
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (5,  2.0, '2025-01-20', 'EXAM', '2024/2025', 1, 1, 1); -- EXAM (nie END) -> ignorowany
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (6,  2.0, '2021-02-10', 'END',  '2021/2022', 1, 1, 4); -- END z semestru 1 -> ignorowany (inny semestr)

-- Nowak: obie proby Inzynierii ponizej 3.0 -> canGraduate=false
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (7,  2.0, '2025-02-10', 'END', '2024/2025', 1, 2, 1); -- Inzynieria proba 1: oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (8,  2.5, '2025-03-05', 'END', '2024/2025', 2, 2, 1); -- Inzynieria proba 2: oblana (2.5) - liczy sie
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (9,  4.0, '2025-02-12', 'END', '2024/2025', 1, 2, 2); -- Sieci: zdane
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (10, 3.0, '2025-02-15', 'END', '2024/2025', 1, 2, 3); -- Bazy: zdane (dokladnie 3.0 = granica)


-- ============================================================================
-- S2: Powrot studenta z urlopu dziekanskiego
-- Metoda + URL: POST /scenario/return-from-leave?indexNumber={indeks}&semester={nr}
-- Oczekiwany wynik:
--   indexNumber=777777 semester=5  200 OK, student status=ACTIVE semester=5
--   indexNumber=123456 semester=5  409 Conflict (Kowalski nie jest na DEAN_LEAVE)
--   indexNumber=999999 semester=5  404 Not Found
-- ============================================================================

insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (3, 'Piotr', 'Wisniewski', '777777', 'piotr.wisniewski@example.com', 4, 'Informatyka', 'DEAN_LEAVE', '2023-10-01', null);


-- ============================================================================
-- S3: Rozliczenie semestru
-- Metoda + URL: POST /scenario/semester-settlement?academicYear=2024/2025
-- Oczekiwany wynik (wszyscy aktywni studenci):
--   Lewandowski  sem=3  failedSubjects=[]                       promoted=true  (remaining=30)
--   Dabrowska    sem=3  failedSubjects=[Matematyka dyskretna]   promoted=true  (remaining=24)
--   Zielinski    sem=3  failedSubjects=[PO, Matematyka dyskr.]  promoted=false (remaining=17)
--   Kowalski     sem=7  failedSubjects=[]                       promoted=false (semestr=7)
--   Nowak        sem=7  failedSubjects=[Inzynieria oprog.]      promoted=false (semestr=7)
-- Sprawdza: prog 21 ECTS (70% z 30), wykluczenie semestru 7, poprawnosc sumy ECTS
-- Uwaga: subjects 5-7 i students 4-6 uzywane rowniez w S5
-- ============================================================================

-- subjects semestru 3 (takze uzywane w S5 i przez grade 57 w S7)
insert into subject(id, name, ects, semester_number) values (5, 'Programowanie obiektowe', 7, 3);
insert into subject(id, name, ects, semester_number) values (6, 'Matematyka dyskretna',    6, 3);
insert into subject(id, name, ects, semester_number) values (7, 'Systemy operacyjne',      5, 3);

-- students semestru 3 (takze uzywani w S5)
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (4, 'Tomasz',   'Lewandowski', '300001', 't.lewandowski@example.com', 3, 'Informatyka', 'ACTIVE', '2023-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (5, 'Karolina', 'Dabrowska',   '300002', 'k.dabrowska@example.com',   3, 'Informatyka', 'ACTIVE', '2023-10-01', null);
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (6, 'Michal',   'Zielinski',   '300003', 'm.zielinski@example.com',   3, 'Informatyka', 'ACTIVE', '2023-10-01', null);

-- Lewandowski: wszystkie zdane -> failedEcts=0, remaining=30 -> promoted=true
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (11, 4.0, '2025-02-10', 'END', '2024/2025', 1, 4, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (12, 3.5, '2025-02-10', 'END', '2024/2025', 1, 4, 6);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (13, 5.0, '2025-02-10', 'END', '2024/2025', 1, 4, 7);

-- Dabrowska: Matematyka oblana (6 ECTS) -> failedEcts=6, remaining=24 -> promoted=true (warunkowo)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (14, 4.0, '2025-02-10', 'END', '2024/2025', 1, 5, 5);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (15, 2.0, '2025-02-10', 'END', '2024/2025', 1, 5, 6); -- Matematyka oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (16, 3.0, '2025-02-10', 'END', '2024/2025', 1, 5, 7);

-- Zielinski: PO (7 ECTS) + Matematyka (6 ECTS) oblane -> failedEcts=13, remaining=17 -> promoted=false
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (17, 2.0, '2025-02-10', 'END', '2024/2025', 1, 6, 5); -- PO oblane
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (18, 2.0, '2025-02-10', 'END', '2024/2025', 1, 6, 6); -- Matematyka oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (19, 4.0, '2025-02-10', 'END', '2024/2025', 1, 6, 7);


-- ============================================================================
-- S4: Wyplata za zajecia dla instruktora
-- Metoda + URL: POST /scenario/instructor-payment?academicYear=2024/2025
-- Oczekiwany wynik:
--   Profesorski  prof.   5 h/tydz (2 obsady zsumowane)  wyplata=3000.0 PLN
--   Doktorska    dr      4 h/tydz (1 obsada)             wyplata=1600.0 PLN
--   Magistrowski mgr     6 h/tydz (1 obsada)             wyplata=1920.0 PLN
-- Dla academicYear=2023/2024: tylko Doktorska (10h, wyplata=4000.0)
-- Sprawdza: sumowanie wielu obsad (instr 1), filtr roku (assignment 5 wyklucza sie z 2024/2025)
-- Uwaga: instructors 1-3 i assignments 1-5 uzywane rowniez w S6 i S8
-- ============================================================================

insert into instructor(id, first_name, last_name, email, title, department)
  values (1, 'Adam',   'Profesorski',  'a.profesorski@example.com',  'prof.', 'Informatyka');
insert into instructor(id, first_name, last_name, email, title, department)
  values (2, 'Barbara','Doktorska',    'b.doktorska@example.com',    'dr',    'Informatyka');
insert into instructor(id, first_name, last_name, email, title, department)
  values (3, 'Cezary', 'Magistrowski', 'c.magistrowski@example.com', 'mgr',   'Informatyka');

-- Profesorski: 2 obsady w 2024/2025 -> suma 2+3=5h/tydz; assignment 1 takze historia dla S8
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (1, '2024/2025', 'LECTURER',            2, 1, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (2, '2024/2025', 'LECTURER',            3, 2, 1);
-- Doktorska: 1 obsada w 2024/2025
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (3, '2024/2025', 'LAB_INSTRUCTOR',       4, 3, 2);
-- Magistrowski: 1 obsada w 2024/2025
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (4, '2024/2025', 'EXERCISE_INSTRUCTOR',  6, 5, 3);
-- Doktorska w innym roku: sprawdza filtr academicYear (wykluczona z 2024/2025)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (5, '2023/2024', 'LECTURER',            10, 4, 2);


-- ============================================================================
-- S5: Ranking studentow i stypendia
-- Metoda + URL: POST /scenario/scholarship-ranking?fieldOfStudy=Informatyka
-- Oczekiwany wynik (srednia wazona = suma(ocena*ects)/30 z poprzedniego semestru):
--   1. Lewandowski  srednia ~4.77  (wszystkie wysokie)
--   2. Dabrowska    srednia ~3.77
--   3. Zielinski    srednia ~3.13
--   4. Kowalski     srednia  0.00  (brak ocen z semestru 6 - poprzedniego dla sem 7)
--   5. Nowak        srednia  0.00  (brak ocen z semestru 6)
-- Dla fieldOfStudy=Automatyka: tylko Mazur ze srednia 5.00
-- Sprawdza: filtr kierunku (Mazur nie wchodzi do rankingu Informatyki), sortowanie, top 10
-- ============================================================================

-- subjects semestru 2 (poprzedni semestr dla students 4-6 z semestru 3)
insert into subject(id, name, ects, semester_number) values (8,  'Analiza matematyczna',       8, 2);
insert into subject(id, name, ects, semester_number) values (9,  'Fizyka',                     7, 2);
insert into subject(id, name, ects, semester_number) values (10, 'Programowanie strukturalne',  8, 2);
insert into subject(id, name, ects, semester_number) values (11, 'Jezyk angielski',             7, 2);

-- student z kierunku Automatyka: sprawdza filtr fieldOfStudy
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (7, 'Ewa', 'Mazur', '300004', 'e.mazur@example.com', 3, 'Automatyka', 'ACTIVE', '2023-10-01', null);

-- Lewandowski: wysokie oceny -> srednia (5*8+4.5*7+5*8+4.5*7)/30 = 143/30 ~4.77
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (20, 5.0, '2024-06-20', 'END', '2023/2024', 1, 4,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (21, 4.5, '2024-06-20', 'END', '2023/2024', 1, 4,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (22, 5.0, '2024-06-20', 'END', '2023/2024', 1, 4, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (23, 4.5, '2024-06-20', 'END', '2023/2024', 1, 4, 11);

-- Dabrowska: srednie oceny -> srednia (4*8+3.5*7+4*8+3.5*7)/30 = 113/30 ~3.77
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (24, 4.0, '2024-06-20', 'END', '2023/2024', 1, 5,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (25, 3.5, '2024-06-20', 'END', '2023/2024', 1, 5,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (26, 4.0, '2024-06-20', 'END', '2023/2024', 1, 5, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (27, 3.5, '2024-06-20', 'END', '2023/2024', 1, 5, 11);

-- Zielinski: nizsze oceny -> srednia (3*8+3*7+3.5*8+3*7)/30 = 94/30 ~3.13
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (28, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (29, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (30, 3.5, '2024-06-20', 'END', '2023/2024', 1, 6, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (31, 3.0, '2024-06-20', 'END', '2023/2024', 1, 6, 11);

-- Mazur (Automatyka): wszystkie 5.0 -> srednia 5.0; sprawdza filtr fieldOfStudy
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (32, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7,  8);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (33, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7,  9);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (34, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 10);
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (35, 5.0, '2024-06-20', 'END', '2023/2024', 1, 7, 11);


-- ============================================================================
-- S6: Identyfikacja przedmiotow problemowych
-- Metoda + URL: POST /scenario/problematic-subjects
--              ?academicYears=2021/2022,2022/2023&threshold=0.3
-- Oczekiwany wynik (przedmioty, gdzie w KAZDYM roku odsetek oblanych >= 30%):
--   Statystyka (id=12):           2021/2022=75.0%, 2022/2023=66.7%  -> KWALIFIKUJE
--   Rachunek rozniczkowy (id=13): 2021/2022=75.0%, 2022/2023=66.7%  -> KWALIFIKUJE
--   Historia informatyki (id=14): 2021/2022=100%,  2022/2023=0.0%   -> NIE KWALIFIKUJE
-- Sprawdza: filtr "kazdy rok musi przekraczac prog", deduplikacja prowadzacych
-- Uwaga: instructor 4 uzywany rowniez w S8; students 8-11 pojawia sie tez w raporcie S7
-- ============================================================================

insert into subject(id, name, ects, semester_number) values (12, 'Statystyka',              5, 4);
insert into subject(id, name, ects, semester_number) values (13, 'Rachunek rozniczkowy',    6, 2);
insert into subject(id, name, ects, semester_number) values (14, 'Historia informatyki',    2, 1);

-- instructor 4: uzywany w S6 i S8
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

-- obsady do wyswietlenia prowadzacych w raporcie
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (6,  '2021/2022', 'LECTURER',           3, 12, 1); -- Statystyka: Profesorski
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (7,  '2022/2023', 'LECTURER',           3, 12, 4); -- Statystyka: Docentska
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (8,  '2021/2022', 'LECTURER',           4, 13, 2); -- Rachunek: Doktorska
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (9,  '2022/2023', 'LECTURER',           4, 13, 4); -- Rachunek: Docentska
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (10, '2021/2022', 'EXERCISE_INSTRUCTOR', 2, 14, 3); -- Historia: Magistrowski
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (11, '2022/2023', 'EXERCISE_INSTRUCTOR', 2, 14, 3); -- Historia: Magistrowski

-- Statystyka (id=12): 2021/2022 -> 3 oblane / 4 = 75%; 2022/2023 -> 2 oblane / 3 = 66.7%
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (36, 2.0, '2022-02-10', 'END', '2021/2022', 1,  8, 12); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (37, 2.0, '2022-02-10', 'END', '2021/2022', 1,  9, 12); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (38, 2.0, '2022-02-10', 'END', '2021/2022', 1, 10, 12); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (39, 4.0, '2022-02-10', 'END', '2021/2022', 1, 11, 12); -- zdana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (40, 2.0, '2023-02-10', 'END', '2022/2023', 1,  8, 12); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (41, 2.0, '2023-02-10', 'END', '2022/2023', 1,  9, 12); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (42, 5.0, '2023-02-10', 'END', '2022/2023', 1, 11, 12); -- zdana

-- Rachunek rozniczkowy (id=13): 2021/2022 -> 3/4=75%; 2022/2023 -> 2/3=66.7%
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (43, 2.0, '2022-06-15', 'END', '2021/2022', 1,  8, 13); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (44, 2.0, '2022-06-15', 'END', '2021/2022', 1,  9, 13); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (45, 2.0, '2022-06-15', 'END', '2021/2022', 1, 10, 13); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (46, 3.5, '2022-06-15', 'END', '2021/2022', 1, 11, 13); -- zdana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (47, 2.0, '2023-06-15', 'END', '2022/2023', 1,  8, 13); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (48, 2.0, '2023-06-15', 'END', '2022/2023', 1, 10, 13); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (49, 4.0, '2023-06-15', 'END', '2022/2023', 1, 11, 13); -- zdana

-- Historia informatyki (id=14): 2021/2022 -> 4/4=100%; 2022/2023 -> 0/3=0% -> NIE kwalifikuje
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (50, 2.0, '2022-01-20', 'END', '2021/2022', 1,  8, 14); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (51, 2.0, '2022-01-20', 'END', '2021/2022', 1,  9, 14); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (52, 2.0, '2022-01-20', 'END', '2021/2022', 1, 10, 14); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (53, 2.0, '2022-01-20', 'END', '2021/2022', 1, 11, 14); -- oblana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (54, 4.0, '2023-01-20', 'END', '2022/2023', 1,  8, 14); -- zdana  <- rok 2022/2023: 0 oblanych -> odpada
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (55, 5.0, '2023-01-20', 'END', '2022/2023', 1,  9, 14); -- zdana
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (56, 4.5, '2023-01-20', 'END', '2022/2023', 1, 10, 14); -- zdana


-- ============================================================================
-- S7: Detekcja rezygnacji
-- Metoda + URL: POST /scenario/resignation-detection?academicYear=2024/2025
-- Oczekiwany wynik (aktywni bez ocen w 2024/2025, zapisani > 3 mies. temu):
--   Widmo      indeks=500001  lastGradeDate=2022-06-15  (ma ocene historyczna)
--   Mazur      indeks=300004  lastGradeDate=2024-06-20  (oceny z 2023/2024)
--   Wojcik     indeks=400001  lastGradeDate=2023-06-15  (oceny z S6)
--   Kaminski   indeks=400002  lastGradeDate=2023-06-15
--   Nowacka    indeks=400003  lastGradeDate=2023-06-15
--   Michalski  indeks=400004  lastGradeDate=2022-01-20
--   Swiezak    NIE POJAWIA SIE -> enrollment=2026-05-01 (swiezej niz 3 mies.)
-- Sprawdza: wykluczenie studentow z ocenami w danym roku, wykluczenie swiezych zapisow
-- ============================================================================

-- student "duch": aktywny, brak ocen w 2024/2025, enrollment dawno -> pojawia sie w raporcie
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (12, 'Krzysztof', 'Widmo',   '500001', 'k.widmo@example.com',   4, 'Informatyka', 'ACTIVE', '2020-10-01', null);
-- student swiezo zapisany: enrollment < 3 mies. -> NIE pojawia sie w raporcie
insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date)
  values (13, 'Natalia',   'Swiezak', '500002', 'n.swiezak@example.com', 1, 'Informatyka', 'ACTIVE', '2026-05-01', null);

-- ocena historyczna dla Widmo: ustawia lastGradeDate na 2022-06-15 (widoczne w raporcie)
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id)
  values (57, 3.0, '2022-06-15', 'END', '2022/2023', 1, 12, 5);


-- ============================================================================
-- S8: Nominacja prowadzacego przedmiotu w nowym roku akademickim
-- Metoda + URL: POST /scenario/nominate-instructor
--              ?subjectId=1&role=LECTURER&academicYear=2025/2026
--              (opcjonalnie: &maxHoursPerWeek=20)
-- Oczekiwany wynik:
--   Doktorska  dr  yearsWithSubject=2  hoursAlreadyPlanned=4   -> KANDYDATKA
--   Profesorski    yearsWithSubject=2  hoursAlreadyPlanned=22  -> WYKLUCZONA (>= 20h)
--   Docentska      brak historii z subj.1                      -> WYKLUCZONA
--   Magistrowski   brak historii + tytul nie kwalifikuje        -> WYKLUCZONA
-- Sprawdza: filtr tytulu do roli (mgr nie moze byc LECTURER), doswiadczenie z przedmiotem,
--           filtr przeciazenia w docelowym roku
-- Uwaga: subj 1 i instructors 1,2 juz wstawione w S1/S4; tu tylko obsady historyczne i load 2025/2026
-- ============================================================================

-- historia doswiadczen z subject 1 (Inzynieria oprogramowania) - bez docelowego roku 2025/2026
-- Profesorski: prowadzil subj.1 w 2023/2024 (+ assignment 1 z S4: 2024/2025) -> 2 lata
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (12, '2023/2024', 'LECTURER', 3, 1, 1);
-- Doktorska: prowadzila subj.1 w 2023/2024 i 2024/2025 -> 2 lata doswiadczenia
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (13, '2023/2024', 'LECTURER', 3, 1, 2);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (14, '2024/2025', 'LECTURER', 3, 1, 2);

-- obciazenie prowadzacych w docelowym roku 2025/2026
-- Profesorski: 12+10=22h/tydz -> PRZECIAZONY (>= maxHoursPerWeek=20)
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (15, '2025/2026', 'LECTURER', 12, 2, 1);
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (16, '2025/2026', 'LECTURER', 10, 3, 1);
-- Doktorska: tylko 4h/tydz -> nie przeciazona
insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id)
  values (17, '2025/2026', 'LAB_INSTRUCTOR', 4, 5, 2);


-- ============================================================================
-- Reset sekwencji
-- ============================================================================
alter sequence student_seq          restart with (select max(id) + 1 from student);
alter sequence subject_seq          restart with (select max(id) + 1 from subject);
alter sequence grade_seq            restart with (select max(id) + 1 from grade);
alter sequence instructor_seq       restart with (select max(id) + 1 from instructor);
alter sequence subject_assignment_seq restart with (select max(id) + 1 from subject_assignment);