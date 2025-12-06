--1
SELECT w.*
FROM workshops w
JOIN festivals f ON w.festival_id = f.id
WHERE w.level = 'napredna'
  AND EXTRACT(YEAR FROM f.start_date) = 2025;
--2
SELECT p.name AS performer,
       f.name AS festival,
       s.name AS stage,
       perf.start_ts
FROM performances perf
JOIN performers p ON perf.performer_id = p.id
JOIN stages s ON perf.stage_id = s.id
JOIN festivals f ON perf.festival_id = f.id
WHERE perf.expected_attendance > 10000;
--3
SELECT *
FROM festivals
WHERE EXTRACT(YEAR FROM start_date) = 2025
   OR EXTRACT(YEAR FROM end_date) = 2025;
--4
SELECT *
FROM workshops
WHERE level = 'napredna';
--5
SELECT *
FROM workshops
WHERE duration_hours > 4;
--6
SELECT *
FROM workshops
WHERE requires_prior_knowledge = TRUE;
--7
SELECT *
FROM mentors
WHERE years_experience > 10;
--8
SELECT *
FROM mentors
WHERE date_of_birth < '1985-01-01';
--9 
SELECT *
FROM visitors
WHERE city = 'Split';
--10
SELECT *
FROM visitors
WHERE email LIKE '%@gmail.com';
--11
SELECT *
FROM visitors
WHERE age(date_of_birth) < INTERVAL '25 years';
--12
SELECT *
FROM tickets
WHERE price > 120;
--13
SELECT *
FROM tickets
WHERE type = 'VIP';
--14
SELECT *
FROM tickets
WHERE valid_for_entire_festival = TRUE;
--15
SELECT *
FROM staff
WHERE security_training = TRUE;










