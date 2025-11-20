-- 1. Estadísticas por departamento (número de ingresos)
SELECT d.nombre, COUNT(i.ingreso_id) AS total_ingresos
FROM departamento d
LEFT JOIN medico m ON m.depto_id = d.depto_id
LEFT JOIN ingreso i ON i.medico_id = m.medico_id
GROUP BY d.nombre;

-- 2. Histórico de un paciente
SELECT p.nombre, i.ingreso_id, i.fecha_ingreso, i.fecha_alta, i.diagnostico
FROM paciente p
JOIN ingreso i ON p.paciente_id = i.paciente_id
WHERE p.dni = '12345678';

-- 3. Ocupación de camas
SELECT d.nombre AS departamento, 
       COUNT(c.cama_id) FILTER (WHERE c.estado='ocupada') AS ocupadas,
       COUNT(c.cama_id) AS total
FROM cama c
JOIN departamento d ON d.depto_id = c.depto_id
GROUP BY d.nombre;

-- 4. Medicamentos más prescritos
SELECT medicamento, COUNT(*) AS veces_recetado
FROM prescripcion
GROUP BY medicamento
ORDER BY veces_recetado DESC
LIMIT 10;

-- 5. Médicos con más consultas
SELECT m.nombre, COUNT(i.ingreso_id) AS consultas
FROM medico m
LEFT JOIN ingreso i ON m.medico_id = i.medico_id
GROUP BY m.nombre
ORDER BY consultas DESC;
