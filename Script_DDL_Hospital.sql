CREATE TABLE departamento (
    depto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE paciente (
    paciente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    fecha_nacimiento DATE,
    direccion TEXT,
    telefono VARCHAR(20)
);

CREATE TABLE medico (
    medico_id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    especialidad VARCHAR(100),
    depto_id INT REFERENCES departamento(depto_id)
);

CREATE TABLE cama (
    cama_id SERIAL PRIMARY KEY,
    depto_id INT REFERENCES departamento(depto_id),
    estado VARCHAR(20) CHECK (estado IN ('libre','ocupada'))
);

CREATE TABLE ingreso (
    ingreso_id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES paciente(paciente_id),
    medico_id INT REFERENCES medico(medico_id),
    cama_id INT REFERENCES cama(cama_id),
    fecha_ingreso TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_alta TIMESTAMP NULL,
    diagnostico TEXT
);

CREATE TABLE prescripcion (
    prescripcion_id SERIAL PRIMARY KEY,
    ingreso_id INT REFERENCES ingreso(ingreso_id),
    medicamento VARCHAR(200) NOT NULL,
    dosis VARCHAR(100),
    fecha_prescripcion TIMESTAMP NOT NULL DEFAULT NOW()
);
