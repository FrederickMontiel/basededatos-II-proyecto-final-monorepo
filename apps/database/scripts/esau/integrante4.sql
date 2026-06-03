/* *****************PROCEDIMIENTO: Registrar actividades************************************/
   
CREATE OR ALTER PROCEDURE dbo.sp_registrar_actividad
(
    @id_actividad INT,
    @numero_actividad VARCHAR(30),
    @id_cliente INT,
    @id_contacto INT = NULL,
    @id_oportunidad INT = NULL,
    @id_usuario_responsable INT,
    @id_tipo_actividad INT,
    @id_prioridad_actividad INT,
    @id_estado_actividad INT = NULL,
    @id_finalizacion_actividad INT = NULL,
    @asunto VARCHAR(150),
    @fecha_actividad DATE,
    @hora_inicio TIME,
    @hora_final TIME = NULL,
    @comentario VARCHAR(500) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @duracion_minutos INT;
    IF @hora_final IS NOT NULL AND @hora_final <= @hora_inicio
    BEGIN
        THROW 50001, 'La hora final debe ser mayor que la hora de inicio.', 1;
    END;
    SET @duracion_minutos = 
        CASE 
            WHEN @hora_final IS NOT NULL 
            THEN dbo.fn_calcular_duracion_actividad(@hora_inicio, @hora_final)
            ELSE NULL
        END;
    INSERT INTO actividad
    (
        id_actividad,
        numero_actividad,
        id_cliente,
        id_contacto,
        id_oportunidad,
        id_usuario_responsable,
        id_tipo_actividad,
        id_prioridad_actividad,
        id_estado_actividad,
        id_finalizacion_actividad,
        asunto,
        fecha_actividad,0
        hora_inicio,
        hora_final,
        duracion_minutos,
        comentario,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES
    (
        @id_actividad,
        @numero_actividad,
        @id_cliente,
        @id_contacto,
        @id_oportunidad,
        @id_usuario_responsable,
        @id_tipo_actividad,
        @id_prioridad_actividad,
        @id_estado_actividad,
        @id_finalizacion_actividad,
        @asunto,
        @fecha_actividad,
        @hora_inicio,
        @hora_final,
        @duracion_minutos,
        @comentario,
        GETDATE(),
        GETDATE()
    );
END;
GO


/* **********************PROCEDIMIENTO: Actualizar actividades******************************/
   
   
CREATE OR ALTER PROCEDURE dbo.sp_actualizar_actividad
(
    @id_actividad INT,
    @id_tipo_actividad INT,
    @id_prioridad_actividad INT,
    @id_estado_actividad INT = NULL,
    @id_finalizacion_actividad INT = NULL,
    @asunto VARCHAR(150),
    @fecha_actividad DATE,
    @hora_inicio TIME,
    @hora_final TIME = NULL,
    @comentario VARCHAR(500) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @duracion_minutos INT;
    IF NOT EXISTS (SELECT 1 FROM actividad WHERE id_actividad = @id_actividad)
    BEGIN
        THROW 50002, 'La actividad indicada no existe.', 1;
    END;
    IF @hora_final IS NOT NULL AND @hora_final <= @hora_inicio
    BEGIN
        THROW 50003, 'La hora final debe ser mayor que la hora de inicio.', 1;
    END;
    SET @duracion_minutos =
        CASE 
            WHEN @hora_final IS NOT NULL
            THEN dbo.fn_calcular_duracion_actividad(@hora_inicio, @hora_final)
            ELSE NULL
        END;

    UPDATE actividad
    SET
        id_tipo_actividad = @id_tipo_actividad,
        id_prioridad_actividad = @id_prioridad_actividad,
        id_estado_actividad = @id_estado_actividad,
        id_finalizacion_actividad = @id_finalizacion_actividad,
        asunto = @asunto,
        fecha_actividad = @fecha_actividad,
        hora_inicio = @hora_inicio,
        hora_final = @hora_final,
        duracion_minutos = @duracion_minutos,
        comentario = @comentario,
        fecha_actualizacion = GETDATE()
    WHERE id_actividad = @id_actividad;
END;
GO


/* *********************PROCEDIMIENTO: Cerrar actividades********************************/
   
CREATE OR ALTER PROCEDURE dbo.sp_cerrar_actividad
(
    @id_actividad INT,
    @comentario_cierre VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id_finalizacion_cerrado INT;
    SELECT @id_finalizacion_cerrado = id_finalizacion_actividad
    FROM finalizacion_actividad
    WHERE nombre_finalizacion = 'Cerrado';
    IF @id_finalizacion_cerrado IS NULL
    BEGIN
        THROW 50004, 'No existe la finalización Cerrado en la tabla finalizacion_actividad.', 1;
    END;
    UPDATE actividad
    SET
        id_finalizacion_actividad = @id_finalizacion_cerrado,
        comentario = CONCAT(ISNULL(comentario, ''), ' | Cierre: ', @comentario_cierre),
        fecha_actualizacion = GETDATE()
    WHERE id_actividad = @id_actividad;
END;
GO


/* *************************PROCEDIMIENTO: Consultar actividades por cliente****************************/
   
CREATE OR ALTER PROCEDURE dbo.sp_consultar_actividades_por_cliente
(
    @id_cliente INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        a.id_actividad,
        a.numero_actividad,
        c.nombre_comercial AS cliente,
        co.nombre_contacto AS contacto,
        ta.nombre_tipo AS tipo_actividad,
        pa.nombre_prioridad AS prioridad,
        ea.nombre_estado AS estado_actividad,
        fa.nombre_finalizacion AS finalizacion,
        a.asunto,
        a.fecha_actividad,
        a.hora_inicio,
        a.hora_final,
        a.duracion_minutos,
        a.comentario
    FROM actividad a
    INNER JOIN cliente c 
        ON a.id_cliente = c.id_cliente
    LEFT JOIN contacto co 
        ON a.id_contacto = co.id_contacto
    INNER JOIN tipo_actividad ta 
        ON a.id_tipo_actividad = ta.id_tipo_actividad
    INNER JOIN prioridad_actividad pa 
        ON a.id_prioridad_actividad = pa.id_prioridad_actividad
    LEFT JOIN estado_actividad ea 
        ON a.id_estado_actividad = ea.id_estado_actividad
    LEFT JOIN finalizacion_actividad fa 
        ON a.id_finalizacion_actividad = fa.id_finalizacion_actividad
    WHERE a.id_cliente = @id_cliente
    ORDER BY a.fecha_actividad DESC, a.hora_inicio DESC;
END;
GO


/* **********************PROCEDIMIENTO: Consultar actividades por oportunidad*******************************/
CREATE OR ALTER PROCEDURE dbo.sp_consultar_actividades_por_oportunidad
(
    @id_oportunidad INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        a.id_actividad,
        a.numero_actividad,
        o.nombre_oportunidad,
        c.nombre_comercial AS cliente,
        co.nombre_contacto AS contacto,
        ta.nombre_tipo AS tipo_actividad,
        pa.nombre_prioridad AS prioridad,
        ea.nombre_estado AS estado_actividad,
        a.asunto,
        a.fecha_actividad,
        a.hora_inicio,
        a.hora_final,
        a.duracion_minutos,
        a.comentario
    FROM actividad a
    INNER JOIN oportunidad o 
        ON a.id_oportunidad = o.id_oportunidad
    INNER JOIN cliente c 
        ON a.id_cliente = c.id_cliente
    LEFT JOIN contacto co 
        ON a.id_contacto = co.id_contacto
    INNER JOIN tipo_actividad ta 
        ON a.id_tipo_actividad = ta.id_tipo_actividad
    INNER JOIN prioridad_actividad pa 
        ON a.id_prioridad_actividad = pa.id_prioridad_actividad
    LEFT JOIN estado_actividad ea 
        ON a.id_estado_actividad = ea.id_estado_actividad
    WHERE a.id_oportunidad = @id_oportunidad
    ORDER BY a.fecha_actividad DESC, a.hora_inicio DESC;
END;
GO

/* ***********************FUNCIÓN: Calcular duración de actividad******************************/
   
CREATE OR ALTER FUNCTION dbo.fn_calcular_duracion_actividad
(
    @hora_inicio TIME,
    @hora_final TIME
)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(MINUTE, @hora_inicio, @hora_final);
END;
GO



    
/* ***********************TRIGGER: Validar campos según tipo de actividad******************************/
   
CREATE OR ALTER TRIGGER dbo.trg_validar_tipo_actividad
ON actividad
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN tipo_actividad ta
            ON i.id_tipo_actividad = ta.id_tipo_actividad
        WHERE ta.nombre_tipo = 'Tarea'
          AND i.id_estado_actividad IS NULL
    )
    BEGIN
        THROW 50005, 'Las actividades de tipo Tarea deben tener estado.', 1;
    END;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN tipo_actividad ta
            ON i.id_tipo_actividad = ta.id_tipo_actividad
        WHERE ta.nombre_tipo = 'Nota'
          AND (
                i.fecha_actividad IS NULL
                OR i.hora_inicio IS NULL
                OR i.id_prioridad_actividad IS NULL
              )
    )
    BEGIN
        THROW 50006, 'Las actividades de tipo Nota deben tener fecha, hora y prioridad.', 1;
    END;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.hora_final IS NOT NULL
          AND i.hora_inicio IS NOT NULL
          AND i.hora_final <= i.hora_inicio
    )
    BEGIN
        THROW 50007, 'La hora final debe ser mayor que la hora de inicio.', 1;
    END;
END;
GO


/* ***********************VALIDACIÓN: No permitir tipos de actividad repetidos******************************/
   
IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UQ_tipo_actividad_nombre_tipo'
      AND object_id = OBJECT_ID('tipo_actividad')
)
BEGIN
    ALTER TABLE tipo_actividad
    ADD CONSTRAINT UQ_tipo_actividad_nombre_tipo UNIQUE (nombre_tipo);
END;
GO


/* ***********************VALIDACIÓN: Campos de detalle de reunión******************************/
   
IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CHK_detalle_reunion_campos'
)
BEGIN
    ALTER TABLE detalle_reunion
    ADD CONSTRAINT CHK_detalle_reunion_campos
    CHECK (
        calle IS NOT NULL
        AND ciudad IS NOT NULL
        AND sala IS NOT NULL
        AND id_estado_actividad IS NOT NULL
    );
END;
GO



/******************PROCEDIMIENTO: Informe de oportunidades por fecha*********************************/
CREATE OR ALTER PROCEDURE dbo.sp_informe_oportunidades_por_fecha
(
    @fecha_inicio DATE,
    @fecha_fin DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.id_oportunidad,
        o.numero_oportunidad,
        o.nombre_oportunidad,
        c.nombre_comercial AS cliente,
        eo.nombre_estado AS estado_oportunidad,
        et.nombre_etapa,
        o.porcentaje_avance,
        o.monto_potencial,
        o.monto_ponderado,
        o.fecha_inicio,
        o.fecha_cierre
    FROM oportunidad o
    INNER JOIN cliente c 
        ON o.id_cliente = c.id_cliente
    INNER JOIN estado_oportunidad eo 
        ON o.id_estado_oportunidad = eo.id_estado_oportunidad
    INNER JOIN etapa_oportunidad et 
        ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
    WHERE o.fecha_inicio BETWEEN @fecha_inicio AND @fecha_fin
    ORDER BY o.fecha_inicio;
END;
GO


/*************************PROCEDIMIENTO: Informe de oportunidades por gestor comercial***************************/
CREATE OR ALTER PROCEDURE dbo.sp_informe_oportunidades_por_gestor
(
    @id_gestor_comercial INT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.id_oportunidad,
        o.numero_oportunidad,
        o.nombre_oportunidad,
        c.nombre_comercial AS cliente,
        u.nombres,
        u.apellidos,
        eo.nombre_estado AS estado_oportunidad,
        et.nombre_etapa,
        o.porcentaje_avance,
        o.monto_potencial,
        o.monto_ponderado,
        o.fecha_inicio,
        o.fecha_cierre
    FROM oportunidad o
    INNER JOIN cliente c 
        ON o.id_cliente = c.id_cliente
    INNER JOIN usuario_comercial u 
        ON o.id_gestor_comercial = u.id_usuario_comercial
    INNER JOIN estado_oportunidad eo 
        ON o.id_estado_oportunidad = eo.id_estado_oportunidad
    INNER JOIN etapa_oportunidad et 
        ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
    WHERE o.id_gestor_comercial = @id_gestor_comercial
    ORDER BY o.fecha_inicio DESC;
END;
GO


/*****************************PROCEDIMIENTO: Informe de oportunidades ganadas o perdidas**************************/
CREATE OR ALTER PROCEDURE dbo.sp_informe_oportunidades_ganadas_perdidas
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.id_oportunidad,
        o.numero_oportunidad,
        o.nombre_oportunidad,
        c.nombre_comercial AS cliente,
        eo.nombre_estado AS estado_oportunidad,
        et.nombre_etapa,
        o.porcentaje_avance,
        o.monto_potencial,
        o.monto_ponderado,
        o.comentario_cierre,
        o.fecha_cierre
    FROM oportunidad o
    INNER JOIN cliente c 
        ON o.id_cliente = c.id_cliente
    INNER JOIN estado_oportunidad eo 
        ON o.id_estado_oportunidad = eo.id_estado_oportunidad
    INNER JOIN etapa_oportunidad et 
        ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
    WHERE eo.nombre_estado IN ('Ganado', 'Perdida')
    ORDER BY o.fecha_cierre DESC;
END;
GO


/* ***********************************
   TRIGGER: Validar cierre de oportunidad
   Solo permite Ganado / Perdida si avance = 100%
   y existe comentario de cierre
*********************************/
CREATE OR ALTER TRIGGER dbo.trg_validar_cierre_oportunidad
ON oportunidad
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN estado_oportunidad eo
            ON i.id_estado_oportunidad = eo.id_estado_oportunidad
        WHERE eo.nombre_estado IN ('Ganado', 'Perdida')
          AND ISNULL(i.porcentaje_avance, 0) < 100
    )
    BEGIN
        THROW 50008, 'La oportunidad solo puede cerrarse como Ganado o Perdida si el avance es 100%.', 1;
    END;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN estado_oportunidad eo
            ON i.id_estado_oportunidad = eo.id_estado_oportunidad
        WHERE eo.nombre_estado IN ('Ganado', 'Perdida')
          AND (
                i.comentario_cierre IS NULL
                OR LTRIM(RTRIM(i.comentario_cierre)) = ''
              )
    )
    BEGIN
        THROW 50009, 'Debe ingresar un comentario de cierre para oportunidades ganadas o perdidas.', 1;
    END;
END;
GO




