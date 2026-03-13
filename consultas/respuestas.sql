-- Laboratorio 2 - SQL Murder Mystery
-- Oliver Quiros

-- 1. Busqué el reporte del crimen ocurrido el 15 de enero de 2018 en SQL City.
-- Descubrí que el reporte menciona dos testigos.
SELECT *
FROM crime_scene_report
WHERE date = 20180115
  AND city = 'SQL City'
  AND type = 'murder';

-- 2. Busqué a la persona que vive en la última casa de Northwestern Dr.
-- Encontré al testigo Morty Schapiro.
SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC;

-- 3. Busqué a la testigo llamada Annabel que vive en Franklin Ave.
-- Encontré a Annabel Miller.
SELECT *
FROM person
WHERE name LIKE '%Annabel%'
  AND address_street_name = 'Franklin Ave';

-- 4. Consulté las entrevistas de los dos testigos.
-- Obtuve pistas sobre el gimnasio, la membresía 48Z, el estado gold y la placa H42W.
SELECT *
FROM interview
WHERE person_id IN (14887, 16371);

-- 5. Busqué miembros del gimnasio Get Fit Now con membresía gold e id que empieza por 48Z.
SELECT *
FROM get_fit_now_member
WHERE id LIKE '48Z%'
  AND membership_status = 'gold';

-- 6. Revisé cuáles de esos miembros hicieron check-in el 9 de enero de 2018.
SELECT m.*, c.*
FROM get_fit_now_member m
JOIN get_fit_now_check_in c
  ON m.id = c.membership_id
WHERE m.id LIKE '48Z%'
  AND m.membership_status = 'gold'
  AND c.check_in_date = 20180109;

-- 7. Crucé los miembros sospechosos con la tabla person para obtener sus nombres reales.
SELECT p.id, p.name, p.license_id, p.address_number, p.address_street_name, m.id AS membership_id
FROM person p
JOIN get_fit_now_member m
  ON p.id = m.person_id
JOIN get_fit_now_check_in c
  ON m.id = c.membership_id
WHERE m.id LIKE '48Z%'
  AND m.membership_status = 'gold'
  AND c.check_in_date = 20180109;

-- 8. Revisé las licencias de conducir de los sospechosos para comparar la pista de la placa.
-- El sospechoso correcto fue Jeremy Bowers.
SELECT p.name, d.id, d.plate_number, d.gender, d.hair_color, d.car_make, d.car_model
FROM person p
JOIN drivers_license d
  ON p.license_id = d.id
WHERE p.name IN ('Joe Germuska', 'Jeremy Bowers');

-- 9. Consulté la entrevista de Jeremy Bowers.
-- Descubrí que fue contratado por otra persona.
SELECT *
FROM interview
WHERE person_id = 67318;

-- 10. Busqué mujeres con cabello rojo, que conduzcan un Tesla Model S y cumplan la descripción dada.
SELECT p.id, p.name, d.hair_color, d.gender, d.height, d.car_make, d.car_model
FROM person p
JOIN drivers_license d
  ON p.license_id = d.id
WHERE d.gender = 'female'
  AND d.hair_color = 'red'
  AND d.car_make = 'Tesla'
  AND d.car_model = 'Model S'
  AND d.height BETWEEN 65 AND 67;

-- 11. Revisé qué personas asistieron varias veces al SQL Symphony Concert en diciembre de 2017.
SELECT person_id, COUNT(*) AS veces
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
  AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id
ORDER BY veces DESC;

-- 12. Crucé la información del auto y apariencia con la asistencia repetida al concierto.
-- La autora intelectual del crimen fue Miranda Priestly.
SELECT p.name, COUNT(*) AS veces
FROM person p
JOIN drivers_license d
  ON p.license_id = d.id
JOIN facebook_event_checkin f
  ON p.id = f.person_id
WHERE d.gender = 'female'
  AND d.hair_color = 'red'
  AND d.car_make = 'Tesla'
  AND d.car_model = 'Model S'
  AND d.height BETWEEN 65 AND 67
  AND f.event_name = 'SQL Symphony Concert'
  AND f.date BETWEEN 20171201 AND 20171231
GROUP BY p.id, p.name
ORDER BY veces DESC;