
--  TABLA: Departamentos
CREATE TABLE Departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(100)
);

--  TABLA: Médicos
CREATE TABLE Medicos (
    id_medico SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    id_departamento INT REFERENCES Departamentos(id_departamento)
);

--  TABLA: Pacientes
CREATE TABLE Pacientes (
    id_paciente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    direccion VARCHAR(150),
    telefono VARCHAR(20),
    seguro_medico VARCHAR(100)
);

--  TABLA: Consultas
CREATE TABLE Consultas (
    id_consulta SERIAL PRIMARY KEY,
    id_paciente INT REFERENCES Pacientes(id_paciente),
    id_medico INT REFERENCES Medicos(id_medico),
    fecha TIMESTAMP NOT NULL,
    motivo TEXT,
    diagnostico TEXT
);

--TABLA: Medicamentos
CREATE TABLE Medicamentos (
    id_medicamento SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    dosis_recomendada VARCHAR(50)
);

--  TABLA: Prescripciones
CREATE TABLE Prescripciones (
    id_prescripcion SERIAL PRIMARY KEY,
    id_consulta INT REFERENCES Consultas(id_consulta),
    id_medicamento INT REFERENCES Medicamentos(id_medicamento),
    dosis VARCHAR(50),
    frecuencia VARCHAR(50),
    duracion VARCHAR(50)
);

--  TABLA: Habitaciones
CREATE TABLE Habitaciones (
    id_habitacion SERIAL PRIMARY KEY,
    numero INT UNIQUE NOT NULL,
    tipo VARCHAR(50),
    disponibilidad BOOLEAN DEFAULT TRUE
);

--  TABLA: Hospitalizaciones
CREATE TABLE Hospitalizaciones (
    id_hosp SERIAL PRIMARY KEY,
    id_paciente INT REFERENCES Pacientes(id_paciente),
    id_habitacion INT REFERENCES Habitaciones(id_habitacion),
    fecha_ingreso TIMESTAMP NOT NULL,
    fecha_alta TIMESTAMP,
    motivo TEXT
);

-- =======================================================
--                      VISTAS
-- =======================================================

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
