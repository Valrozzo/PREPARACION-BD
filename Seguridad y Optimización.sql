
-- 1. CREACIÓN DE ROLES

CREATE ROLE admin_hospital SUPERUSER LOGIN PASSWORD 'admin123';

CREATE ROLE medico NOINHERIT;
CREATE ROLE enfermera NOINHERIT;
CREATE ROLE recepcionista NOINHERIT;
CREATE ROLE paciente NOINHERIT;

-- 2. PERMISOS GENERALES POR ROL

-- Recepcionista: registra y consulta pacientes
GRANT SELECT, INSERT, UPDATE ON paciente TO recepcionista;
GRANT SELECT ON ingreso TO recepcionista;

-- Enfermera: puede ver ingresos y prescripciones
GRANT SELECT ON ingreso TO enfermera;
GRANT SELECT ON prescripcion TO enfermera;

-- Médico: puede ver y editar ingresos de sus pacientes
GRANT SELECT, UPDATE ON ingreso TO medico;
GRANT SELECT, INSERT ON prescripcion TO medico;

-- Paciente: solo puede ver sus propios datos (vía RLS)
GRANT SELECT ON paciente TO paciente;

-- 3. ACTIVAR ROW LEVEL SECURITY (RLS)

ALTER TABLE ingreso ENABLE ROW LEVEL SECURITY;


-- 4. POLÍTICA RLS PARA MÉDICOS
--    Cada médico solo ve sus pacientes

DROP POLICY IF EXISTS ver_solo_mis_pacientes ON ingreso;

CREATE POLICY ver_solo_mis_pacientes
ON ingreso
FOR SELECT
USING (medico_id = current_setting('app.medico_id')::INT);

-- Si editar ingresos también debe estar restringido:
CREATE POLICY editar_solo_mis_pacientes
ON ingreso
FOR UPDATE
USING (medico_id = current_setting('app.medico_id')::INT);

-- 5. POLÍTICA RLS PARA PACIENTES
--    Cada paciente solo puede ver sus propios registros

ALTER TABLE paciente ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ver_solo_mi_ficha ON paciente;

CREATE POLICY ver_solo_mi_ficha
ON paciente
FOR SELECT
USING (paciente_id = current_setting('app.paciente_id')::INT);


-- 6. ÍNDICES ESTRATÉGICOS PARA OPTIMIZACIÓN

-- Consultas por paciente
CREATE INDEX IF NOT EXISTS idx_ingreso_paciente
ON ingreso(paciente_id);

-- Consultas por médico
CREATE INDEX IF NOT EXISTS idx_ingreso_medico
ON ingreso(medico_id);

-- Búsqueda por medicamento
CREATE INDEX IF NOT EXISTS idx_prescripcion_medicamento
ON prescripcion(medicamento);

-- Buscar camas libres/ocupadas rápido
CREATE INDEX IF NOT EXISTS idx_cama_estado
ON cama(estado);

-- 7. EJEMPLOS DE ANÁLISIS DE PLANES DE EJECUCIÓN

-- Estadísticas por paciente
EXPLAIN ANALYZE
SELECT * FROM ingreso WHERE paciente_id = 10;

-- Prescripciones frecuentes
EXPLAIN ANALYZE
SELECT medicamento, COUNT(*)
FROM prescripcion
GROUP BY medicamento;

