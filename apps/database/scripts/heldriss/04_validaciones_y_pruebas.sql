USE InnovacionCRM;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.rol_usuario WHERE id_rol_usuario = 1)
BEGIN
    INSERT INTO dbo.rol_usuario (nombre_rol, descripcion, estado)
    VALUES ('Comercial', 'Usuario del area comercial', 1);
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.usuario_comercial WHERE correo = 'sandra.aroche@innovacion.com')
BEGIN
    INSERT INTO dbo.usuario_comercial
    (
        id_rol_usuario,
        nombres,
        apellidos,
        correo,
        telefono,
        estado,
        fecha_creacion
    )
    VALUES
    (
        1,
        'Sandra',
        'Aroche',
        'sandra.aroche@innovacion.com',
        '5555-1111',
        1,
        GETDATE()
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.cliente WHERE codigo_cliente = 'CLI-001')
BEGIN
    INSERT INTO dbo.cliente
    (
        id_tipo_cliente,
        codigo_cliente,
        nombre_comercial,
        direccion_empresa,
        telefono,
        celular,
        correo_electronico,
        estado,
        fecha_creacion
    )
    VALUES
    (
        1,
        'CLI-001',
        'Cliente Demo Innovacion',
        'Ciudad de Guatemala',
        '2222-2222',
        '5555-2222',
        'cliente.demo@correo.com',
        1,
        GETDATE()
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.contacto WHERE correo_electronico = 'contacto.demo@correo.com')
BEGIN
    INSERT INTO dbo.contacto
    (
        id_cliente,
        nombre_contacto,
        puesto_contacto,
        telefono,
        celular,
        correo_electronico,
        estado,
        fecha_creacion
    )
    VALUES
    (
        (SELECT id_cliente FROM dbo.cliente WHERE codigo_cliente = 'CLI-001'),
        'Contacto Demo',
        'Gerente de Compras',
        '2222-3333',
        '5555-3333',
        'contacto.demo@correo.com',
        1,
        GETDATE()
    );
END;
GO

EXEC dbo.sp_CrearOportunidad
    @numero_oportunidad = 'OP-INT3-001',
    @id_cliente = 1,
    @id_contacto = 1,
    @id_tipo_oportunidad = 1,
    @id_etapa_oportunidad = 1,
    @id_gestor_comercial = 1,
    @id_asistente_comercial = NULL,
    @id_gerente_comercial = NULL,
    @nombre_oportunidad = 'Venta de sistema CRM para cliente demo',
    @cierre_planificado_valor = 15,
    @cierre_planificado_unidad = 'Dias',
    @monto_potencial = 60000.00;
GO

SELECT *
FROM dbo.oportunidad
WHERE numero_oportunidad = 'OP-INT3-001';
GO

EXEC dbo.sp_CambiarEtapaOportunidad
    @id_oportunidad = 1,
    @id_etapa_oportunidad = 4;
GO

SELECT 
    id_oportunidad,
    numero_oportunidad,
    id_etapa_oportunidad,
    porcentaje_avance,
    monto_potencial,
    monto_ponderado
FROM dbo.oportunidad
WHERE id_oportunidad = 1;
GO

BEGIN TRY
    EXEC dbo.sp_CerrarOportunidad
        @id_oportunidad = 1,
        @id_estado_oportunidad = 2,
        @comentario_cierre = 'Intento de cierre sin llegar al 100%.';
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Error_Esperado_Cierre_Sin_100;
END CATCH;
GO

EXEC dbo.sp_CambiarEtapaOportunidad
    @id_oportunidad = 1,
    @id_etapa_oportunidad = 6;
GO

BEGIN TRY
    EXEC dbo.sp_CerrarOportunidad
        @id_oportunidad = 1,
        @id_estado_oportunidad = 2,
        @comentario_cierre = '';
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS Error_Esperado_Comentario_Obligatorio;
END CATCH;
GO

EXEC dbo.sp_CerrarOportunidad
    @id_oportunidad = 1,
    @id_estado_oportunidad = 2,
    @comentario_cierre = 'La oportunidad fue ganada porque el cliente acepto la propuesta final.';
GO

SELECT 
    o.id_oportunidad,
    o.numero_oportunidad,
    c.nombre_comercial,
    eo.nombre_estado,
    et.nombre_etapa,
    o.porcentaje_avance,
    o.monto_potencial,
    o.monto_ponderado,
    o.comentario_cierre,
    o.fecha_cierre
FROM dbo.oportunidad o
INNER JOIN dbo.cliente c
    ON o.id_cliente = c.id_cliente
INNER JOIN dbo.estado_oportunidad eo
    ON o.id_estado_oportunidad = eo.id_estado_oportunidad
INNER JOIN dbo.etapa_oportunidad et
    ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
WHERE o.numero_oportunidad = 'OP-INT3-001';
GO

SELECT 
    id_etapa_oportunidad,
    nombre_etapa,
    porcentaje_cierre,
    COUNT(*) AS cantidad
FROM dbo.etapa_oportunidad
GROUP BY id_etapa_oportunidad, nombre_etapa, porcentaje_cierre
HAVING COUNT(*) > 1;
GO

SELECT 
    o.id_oportunidad,
    o.numero_oportunidad,
    o.porcentaje_avance,
    et.porcentaje_cierre AS porcentaje_correcto_etapa
FROM dbo.oportunidad o
INNER JOIN dbo.etapa_oportunidad et
    ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
WHERE o.porcentaje_avance <> et.porcentaje_cierre;
GO