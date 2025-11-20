-- Vista para médicos
CREATE VIEW Vista_Medico AS
SELECT 
    c.id_consulta,
    c.fecha,
    c.motivo,
    c.diagnostico,
    p.id_paciente,
    p.nombre AS nombre_paciente,
    p.apellido AS apellido_paciente
FROM Consultas c
JOIN Pacientes p ON c.id_paciente = p.id_paciente;

-- Vista para pacientes
CREATE VIEW Vista_Paciente AS
SELECT 
    p.id_paciente,
    p.nombre,
    p.apellido,
    c.id_consulta,
    c.fecha AS fecha_consulta,
    c.diagnostico,
    h.fecha_ingreso,
    h.fecha_alta,
    h.motivo AS motivo_hospitalizacion
FROM Pacientes p
LEFT JOIN Consultas c ON p.id_paciente = c.id_paciente
LEFT JOIN Hospitalizaciones h ON p.id_paciente = h.id_paciente;

-- Vista para administración
CREATE VIEW Vista_Administracion AS
SELECT 
    m.id_medico,
    m.nombre AS nombre_medico,
    m.apellido AS apellido_medico,
    m.especialidad,
    d.nombre AS departamento,
    h.id_habitacion,
    h.numero AS numero_habitacion,
    h.tipo,
    h.disponibilidad
FROM Medicos m
JOIN Departamentos d ON m.id_departamento = d.id_departamento
LEFT JOIN Habitaciones h ON TRUE;

