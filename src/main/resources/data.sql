insert into instructor(id, first_name, last_name, email, title, department) values
  (1, 'Kamil',    'Kowal', 'kamil.kowal@polsl.pl', 'dr inż.', 'Informatyka stosowana'),
  (2, 'Anna',     'Nowak',      'anna.nowak@polsl.pl',     'dr hab. inż.',      'Informatyka stosowana'),
  (3, 'Krzysztof','Wiśniewski', 'krzysztof.wysniewski@polsl.pl',       'prof.',   'Katedra Algorytmiki'),
  (4, 'Barbara',  'Zielińska',  'barbara.zielinska@polsl.pl',      'mgr inż.',     'Informatyka stosowana');


insert into subject(id, name, ects, semester_number) values
  (1, 'Podstawy informatyki', 5, 1),
  (2, 'Algorytmika', 3, 2),
  (3, 'Grafika komputerowa', 2, 5),
  (4, 'Analiza matematyczna', 5, 1),
  (5, 'Systemy operacyjne', 4, 4);


insert into student(id, first_name, last_name, index_number, email, semester, field_of_study, status, enrollment_date, graduation_date) values
  (1, 'Jan',     'Kowalski', '123456', 'jw@student.polsl.pl',  5, 'Informatics', 'ACTIVE',     '2022-10-01', null),
  (2, 'Maria',   'Lewandowska', '123457', 'ml@student.polsl.pl',    3, 'Informatics', 'ACTIVE',     '2023-10-01', null),
  (3, 'Piotr',   'Wójcik',  '123458', 'pw@student.polsl.pl',        7, 'Informatics', 'DEAN_LEAVE', '2021-10-01', null),
  (4, 'Katarzyna','Dąbrowska','123459', 'kd@student.polsl.pl',      2, 'Mathematics', 'ACTIVE',     '2024-10-01', null),
  (5, 'Tomasz',  'Szymański','123460', 'tsz@student.polsl.pl',       7, 'Informatics', 'GRADUATED',  '2020-10-01', '2024-07-15'),
  (6, 'Aleksandra','Kamińska','123461', 'ak@student.polsl.pl',        4, 'Informatics', 'EXPELLED',   '2023-02-15', null);


insert into subject_assignment(id, academic_year, role, hours_per_week, subject_id, instructor_id) values
  (1, '2024/2025', 'LECTURER',            2, 1, 1),
  (2, '2024/2025', 'LAB_INSTRUCTOR',      1, 1, 2),
  (3, '2024/2025', 'LECTURER',            2, 2, 1),
  (4, '2024/2025', 'EXERCISE_INSTRUCTOR', 1, 2, 4),
  (5, '2024/2025', 'LECTURER',            1, 3, 2),
  (6, '2024/2025', 'LECTURER',            2, 4, 3),
  (7, '2023/2024', 'LECTURER',            1, 5, 1);

-- grade -> grade_value
insert into grade(id, grade_value, date_issued, grade_type, academic_year, attempt_number, student_id, subject_id, instructor_id) values
  (1, 4.5, '2025-01-25', 'EXAM',       '2024/2025', 1, 1, 1, 1),
  (2, 5.0, '2025-01-20', 'PROJECT',    '2024/2025', 1, 1, 2, 1),
  (3, 3.5, '2025-01-22', 'MIDTERM',    '2024/2025', 1, 1, 3, 2),
  (4, 4.0, '2025-01-25', 'EXAM',       '2024/2025', 1, 2, 1, 1),
  (5, 3.0, '2025-01-20', 'EXAM',       '2024/2025', 1, 2, 3, 2),
  (6, 2.0, '2025-02-01', 'EXAM',       '2024/2025', 1, 4, 4, 3),
  (7, 4.0, '2025-02-15', 'EXAM',       '2024/2025', 2, 4, 4, 3),
  (8, 5.0, '2024-06-20', 'EXAM',       '2023/2024', 1, 5, 5, 1),
  (9, 4.5, '2025-01-18', 'ASSIGNMENT', '2024/2025', 1, 1, 2, 4),
  (10, 3.5, '2025-01-30', 'PROJECT',   '2024/2025', 1, 2, 2, 4);


alter sequence instructor_seq          restart with (select max(id) + 1 from instructor);
alter sequence subject_seq             restart with (select max(id) + 1 from subject);
alter sequence student_seq             restart with (select max(id) + 1 from student);
alter sequence subject_assignment_seq  restart with (select max(id) + 1 from subject_assignment);
alter sequence grade_seq               restart with (select max(id) + 1 from grade);