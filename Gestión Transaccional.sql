
-- 1. TABLA DE AUDITORÍA

CREATE TABLE IF NOT EXISTS audit_log (
    audit_id SERIAL PRIMARY KEY,
    tabla VARCHAR(100),
    operacion VARCHAR(20),
    registro JSONB,
    fecha TIMESTAMP DEFAULT NOW()
);

-- 2. FUNCIÓN DE AUDITORÍA GENÉRICA

CREATE OR REPLACE FUNCTION trg_audit()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_log(tabla, operacion, registro)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD));
        RETURN OLD;
    ELSE
        INSERT INTO audit_log(tabla, operacion, registro)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW));
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 3. TRIGGER QUE REGISTRA CAMBIOS EN INGRESO

DROP TRIGGER IF EXISTS auditoria_ingresos ON ingreso;

CREATE TRIGGER auditoria_ingresos
AFTER INSERT OR UPDATE OR DELETE ON ingreso
FOR EACH ROW EXECUTE FUNCTION trg_audit();

-- 4. PROCEDIMIENTO DE ADMISIÓN DE EMERGENCIA (ACID)
--    CON BLOQUEOS PARA EVITAR DOBLE ASIGNACIÓN DE CAMAS

CREATE OR REPLACE PROCEDURE admision_emergencia(
    p_paciente_id INT,
    p_medico_id INT,
    p_diagnostico TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_cama_id INT;
BEGIN
    -- Inicia transacción explícita
    START TRANSACTION;

    -- Seleccionar cama libre usando bloqueo optimista
    SELECT cama_id INTO v_cama_id
    FROM cama
    WHERE estado = 'libre'
    LIMIT 1
    FOR UPDATE SKIP LOCKED;

    IF v_cama_id IS NULL THEN
        RAISE EXCEPTION 'No hay camas disponibles';
    END IF;

    -- Actualizar estado de la cama
    UPDATE cama
    SET estado = 'ocupada'
    WHERE cama_id = v_cama_id;

    -- Insertar el ingreso del paciente
    INSERT INTO ingreso(paciente_id, medico_id, cama_id, diagnostico)
    VALUES (p_paciente_id, p_medico_id, v_cama_id, p_diagnostico);

    -- Todo OK → commit
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;

