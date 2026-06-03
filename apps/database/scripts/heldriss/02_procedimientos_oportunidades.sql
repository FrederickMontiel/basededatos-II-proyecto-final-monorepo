USE InnovacionCRM;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CrearOportunidad
    @numero_oportunidad VARCHAR(30),
    @id_cliente INT,
    @id_contacto INT,
    @id_tipo_oportunidad INT,
    @id_etapa_oportunidad INT,
    @id_gestor_comercial INT,
    @id_asistente_comercial INT = NULL,
    @id_gerente_comercial INT = NULL,
    @nombre_oportunidad VARCHAR(150),
    @cierre_planificado_valor INT,
    @cierre_planificado_unidad VARCHAR(20),
    @monto_potencial DECIMAL(14,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @porcentaje_avance DECIMAL(5,2);
    DECLARE @monto_ponderado DECIMAL(14,2);
    DECLARE @id_estado_abierto INT;
    DECLARE @fecha_cierre_prevista DATE;

    SELECT @id_estado_abierto = id_estado_oportunidad
    FROM dbo.estado_oportunidad
    WHERE nombre_estado = 'Abierto';

    SET @porcentaje_avance = dbo.fn_ObtenerPorcentajeEtapa(@id_etapa_oportunidad);
    SET @monto_ponderado = dbo.fn_CalcularMontoPonderado(@monto_potencial, @porcentaje_avance);

    IF @cierre_planificado_unidad = 'Dias'
        SET @fecha_cierre_prevista = DATEADD(DAY, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE IF @cierre_planificado_unidad = 'Semanas'
        SET @fecha_cierre_prevista = DATEADD(WEEK, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE IF @cierre_planificado_unidad = 'Meses'
        SET @fecha_cierre_prevista = DATEADD(MONTH, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE
        THROW 50001, 'La unidad de cierre planificado debe ser Dias, Semanas o Meses.', 1;

    INSERT INTO dbo.oportunidad
    (
        numero_oportunidad,
        id_cliente,
        id_contacto,
        id_tipo_oportunidad,
        id_estado_oportunidad,
        id_etapa_oportunidad,
        id_gestor_comercial,
        id_asistente_comercial,
        id_gerente_comercial,
        nombre_oportunidad,
        fecha_inicio,
        fecha_cierre,
        actividades_abiertas,
        porcentaje_avance,
        potencial,
        cierre_planificado_valor,
        cierre_planificado_unidad,
        fecha_cierre_prevista,
        monto_potencial,
        monto_ponderado,
        comentario_cierre,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES
    (
        @numero_oportunidad,
        @id_cliente,
        @id_contacto,
        @id_tipo_oportunidad,
        @id_estado_abierto,
        @id_etapa_oportunidad,
        @id_gestor_comercial,
        @id_asistente_comercial,
        @id_gerente_comercial,
        @nombre_oportunidad,
        CAST(GETDATE() AS DATE),
        NULL,
        0,
        @porcentaje_avance,
        @monto_potencial,
        @cierre_planificado_valor,
        @cierre_planificado_unidad,
        @fecha_cierre_prevista,
        @monto_potencial,
        @monto_ponderado,
        NULL,
        GETDATE(),
        GETDATE()
    );
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_ActualizarOportunidad
    @id_oportunidad INT,
    @nombre_oportunidad VARCHAR(150),
    @id_gestor_comercial INT,
    @id_asistente_comercial INT = NULL,
    @id_gerente_comercial INT = NULL,
    @cierre_planificado_valor INT,
    @cierre_planificado_unidad VARCHAR(20),
    @monto_potencial DECIMAL(14,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_etapa_oportunidad INT;
    DECLARE @porcentaje_avance DECIMAL(5,2);
    DECLARE @monto_ponderado DECIMAL(14,2);
    DECLARE @fecha_cierre_prevista DATE;

    SELECT @id_etapa_oportunidad = id_etapa_oportunidad
    FROM dbo.oportunidad
    WHERE id_oportunidad = @id_oportunidad;

    SET @porcentaje_avance = dbo.fn_ObtenerPorcentajeEtapa(@id_etapa_oportunidad);
    SET @monto_ponderado = dbo.fn_CalcularMontoPonderado(@monto_potencial, @porcentaje_avance);

    IF @cierre_planificado_unidad = 'Dias'
        SET @fecha_cierre_prevista = DATEADD(DAY, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE IF @cierre_planificado_unidad = 'Semanas'
        SET @fecha_cierre_prevista = DATEADD(WEEK, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE IF @cierre_planificado_unidad = 'Meses'
        SET @fecha_cierre_prevista = DATEADD(MONTH, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE
        THROW 50002, 'La unidad de cierre planificado debe ser Dias, Semanas o Meses.', 1;

    UPDATE dbo.oportunidad
    SET nombre_oportunidad = @nombre_oportunidad,
        id_gestor_comercial = @id_gestor_comercial,
        id_asistente_comercial = @id_asistente_comercial,
        id_gerente_comercial = @id_gerente_comercial,
        cierre_planificado_valor = @cierre_planificado_valor,
        cierre_planificado_unidad = @cierre_planificado_unidad,
        fecha_cierre_prevista = @fecha_cierre_prevista,
        monto_potencial = @monto_potencial,
        potencial = @monto_potencial,
        monto_ponderado = @monto_ponderado,
        fecha_actualizacion = GETDATE()
    WHERE id_oportunidad = @id_oportunidad;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CambiarEtapaOportunidad
    @id_oportunidad INT,
    @id_etapa_oportunidad INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @porcentaje_avance DECIMAL(5,2);
    DECLARE @monto_potencial DECIMAL(14,2);
    DECLARE @monto_ponderado DECIMAL(14,2);

    SET @porcentaje_avance = dbo.fn_ObtenerPorcentajeEtapa(@id_etapa_oportunidad);

    SELECT @monto_potencial = monto_potencial
    FROM dbo.oportunidad
    WHERE id_oportunidad = @id_oportunidad;

    SET @monto_ponderado = dbo.fn_CalcularMontoPonderado(@monto_potencial, @porcentaje_avance);

    UPDATE dbo.oportunidad
    SET id_etapa_oportunidad = @id_etapa_oportunidad,
        porcentaje_avance = @porcentaje_avance,
        monto_ponderado = @monto_ponderado,
        fecha_actualizacion = GETDATE()
    WHERE id_oportunidad = @id_oportunidad;
END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CerrarOportunidad
    @id_oportunidad INT,
    @id_estado_oportunidad INT,
    @comentario_cierre VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.oportunidad
    SET id_estado_oportunidad = @id_estado_oportunidad,
        comentario_cierre = @comentario_cierre,
        fecha_cierre = CAST(GETDATE() AS DATE),
        fecha_actualizacion = GETDATE()
    WHERE id_oportunidad = @id_oportunidad;
END;
GO