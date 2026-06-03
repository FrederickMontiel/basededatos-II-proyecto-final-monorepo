-- =========================================================
-- PROYECTO FINAL BASE DE DATOS II
-- Empresa: Innovacion, S.A.
-- Sistema: Seguimiento Comercial / CRM
-- Motor: Microsoft SQL Server 2022
-- =========================================================
-- ARCHIVO UNIFICADO: Contiene estructura, funciones,
-- procedimientos, triggers, validaciones y datos iniciales
-- =========================================================

IF DB_ID('InnovacionCRM') IS NULL
BEGIN
    CREATE DATABASE InnovacionCRM;
END;
GO

USE InnovacionCRM;
GO

-- =========================================================
-- LIMPIEZA DE TABLAS EXISTENTES
-- =========================================================
IF OBJECT_ID('dbo.detalle_reunion', 'U') IS NOT NULL DROP TABLE dbo.detalle_reunion;
IF OBJECT_ID('dbo.actividad', 'U') IS NOT NULL DROP TABLE dbo.actividad;
IF OBJECT_ID('dbo.oportunidad', 'U') IS NOT NULL DROP TABLE dbo.oportunidad;
IF OBJECT_ID('dbo.contacto', 'U') IS NOT NULL DROP TABLE dbo.contacto;
IF OBJECT_ID('dbo.cliente', 'U') IS NOT NULL DROP TABLE dbo.cliente;
IF OBJECT_ID('dbo.usuario_comercial', 'U') IS NOT NULL DROP TABLE dbo.usuario_comercial;
IF OBJECT_ID('dbo.etapa_oportunidad', 'U') IS NOT NULL DROP TABLE dbo.etapa_oportunidad;
IF OBJECT_ID('dbo.estado_oportunidad', 'U') IS NOT NULL DROP TABLE dbo.estado_oportunidad;
IF OBJECT_ID('dbo.tipo_oportunidad', 'U') IS NOT NULL DROP TABLE dbo.tipo_oportunidad;
IF OBJECT_ID('dbo.tipo_cliente', 'U') IS NOT NULL DROP TABLE dbo.tipo_cliente;
IF OBJECT_ID('dbo.tipo_actividad', 'U') IS NOT NULL DROP TABLE dbo.tipo_actividad;
IF OBJECT_ID('dbo.prioridad_actividad', 'U') IS NOT NULL DROP TABLE dbo.prioridad_actividad;
IF OBJECT_ID('dbo.estado_actividad', 'U') IS NOT NULL DROP TABLE dbo.estado_actividad;
IF OBJECT_ID('dbo.finalizacion_actividad', 'U') IS NOT NULL DROP TABLE dbo.finalizacion_actividad;
IF OBJECT_ID('dbo.rol_usuario', 'U') IS NOT NULL DROP TABLE dbo.rol_usuario;
GO

-- =========================================================
-- SECCION 1: CREACION DE TABLAS CATALOGO
-- =========================================================

CREATE TABLE dbo.rol_usuario (
    id_rol_usuario INT IDENTITY(1,1) NOT NULL,
    nombre_rol VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_rol_usuario_estado DEFAULT 1,
    CONSTRAINT pk_rol_usuario PRIMARY KEY (id_rol_usuario),
    CONSTRAINT uq_rol_usuario_nombre UNIQUE (nombre_rol)
);
GO

CREATE TABLE dbo.tipo_cliente (
    id_tipo_cliente INT IDENTITY(1,1) NOT NULL,
    nombre_tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_tipo_cliente_estado DEFAULT 1,
    CONSTRAINT pk_tipo_cliente PRIMARY KEY (id_tipo_cliente),
    CONSTRAINT uq_tipo_cliente_nombre UNIQUE (nombre_tipo)
);
GO

CREATE TABLE dbo.tipo_oportunidad (
    id_tipo_oportunidad INT IDENTITY(1,1) NOT NULL,
    nombre_tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_tipo_oportunidad_estado DEFAULT 1,
    CONSTRAINT pk_tipo_oportunidad PRIMARY KEY (id_tipo_oportunidad),
    CONSTRAINT uq_tipo_oportunidad_nombre UNIQUE (nombre_tipo)
);
GO

CREATE TABLE dbo.estado_oportunidad (
    id_estado_oportunidad INT IDENTITY(1,1) NOT NULL,
    nombre_estado VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_estado_oportunidad_estado DEFAULT 1,
    CONSTRAINT pk_estado_oportunidad PRIMARY KEY (id_estado_oportunidad),
    CONSTRAINT uq_estado_oportunidad_nombre UNIQUE (nombre_estado)
);
GO

CREATE TABLE dbo.etapa_oportunidad (
    id_etapa_oportunidad INT IDENTITY(1,1) NOT NULL,
    nombre_etapa VARCHAR(100) NOT NULL,
    porcentaje_cierre DECIMAL(5,2) NOT NULL,
    orden_etapa INT NOT NULL,
    estado BIT NOT NULL CONSTRAINT df_etapa_oportunidad_estado DEFAULT 1,
    CONSTRAINT pk_etapa_oportunidad PRIMARY KEY (id_etapa_oportunidad),
    CONSTRAINT uq_etapa_oportunidad_nombre UNIQUE (nombre_etapa),
    CONSTRAINT uq_etapa_oportunidad_orden UNIQUE (orden_etapa),
    CONSTRAINT chk_etapa_porcentaje_mssql CHECK (porcentaje_cierre >= 0 AND porcentaje_cierre <= 100)
);
GO

CREATE TABLE dbo.tipo_actividad (
    id_tipo_actividad INT IDENTITY(1,1) NOT NULL,
    nombre_tipo VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_tipo_actividad_estado DEFAULT 1,
    CONSTRAINT pk_tipo_actividad PRIMARY KEY (id_tipo_actividad),
    CONSTRAINT uq_tipo_actividad_nombre UNIQUE (nombre_tipo)
);
GO

CREATE TABLE dbo.prioridad_actividad (
    id_prioridad_actividad INT IDENTITY(1,1) NOT NULL,
    nombre_prioridad VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_prioridad_actividad_estado DEFAULT 1,
    CONSTRAINT pk_prioridad_actividad PRIMARY KEY (id_prioridad_actividad),
    CONSTRAINT uq_prioridad_actividad_nombre UNIQUE (nombre_prioridad)
);
GO

CREATE TABLE dbo.estado_actividad (
    id_estado_actividad INT IDENTITY(1,1) NOT NULL,
    nombre_estado VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_estado_actividad_estado DEFAULT 1,
    CONSTRAINT pk_estado_actividad PRIMARY KEY (id_estado_actividad),
    CONSTRAINT uq_estado_actividad_nombre UNIQUE (nombre_estado)
);
GO

CREATE TABLE dbo.finalizacion_actividad (
    id_finalizacion_actividad INT IDENTITY(1,1) NOT NULL,
    nombre_finalizacion VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_finalizacion_actividad_estado DEFAULT 1,
    CONSTRAINT pk_finalizacion_actividad PRIMARY KEY (id_finalizacion_actividad),
    CONSTRAINT uq_finalizacion_actividad_nombre UNIQUE (nombre_finalizacion)
);
GO

-- =========================================================
-- SECCION 2: CREACION DE TABLAS PRINCIPALES
-- =========================================================

CREATE TABLE dbo.usuario_comercial (
    id_usuario_comercial INT IDENTITY(1,1) NOT NULL,
    id_rol_usuario INT NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(25) NULL,
    estado BIT NOT NULL CONSTRAINT df_usuario_comercial_estado DEFAULT 1,
    ultimo_acceso DATETIME2 NULL,
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT df_usuario_fecha DEFAULT SYSDATETIME(),
    CONSTRAINT pk_usuario_comercial PRIMARY KEY (id_usuario_comercial),
    CONSTRAINT uq_usuario_correo UNIQUE (correo),
    CONSTRAINT fk_usuario_rol_mssql FOREIGN KEY (id_rol_usuario) REFERENCES dbo.rol_usuario(id_rol_usuario)
);
GO

CREATE TABLE dbo.cliente (
    id_cliente INT IDENTITY(1,1) NOT NULL,
    id_tipo_cliente INT NOT NULL,
    codigo_cliente VARCHAR(30) NOT NULL,
    nombre_comercial VARCHAR(150) NOT NULL,
    direccion_empresa VARCHAR(255) NULL,
    telefono VARCHAR(25) NULL,
    celular VARCHAR(25) NULL,
    correo_electronico VARCHAR(120) NULL,
    estado BIT NOT NULL CONSTRAINT df_cliente_estado DEFAULT 1,
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT df_cliente_fecha DEFAULT SYSDATETIME(),
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_codigo UNIQUE (codigo_cliente),
    CONSTRAINT fk_cliente_tipo_mssql FOREIGN KEY (id_tipo_cliente) REFERENCES dbo.tipo_cliente(id_tipo_cliente)
);
GO

CREATE TABLE dbo.contacto (
    id_contacto INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    nombre_contacto VARCHAR(120) NOT NULL,
    puesto_contacto VARCHAR(100) NULL,
    telefono VARCHAR(25) NULL,
    celular VARCHAR(25) NULL,
    correo_electronico VARCHAR(120) NULL,
    estado BIT NOT NULL CONSTRAINT df_contacto_estado DEFAULT 1,
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT df_contacto_fecha DEFAULT SYSDATETIME(),
    CONSTRAINT pk_contacto PRIMARY KEY (id_contacto),
    CONSTRAINT fk_contacto_cliente_mssql FOREIGN KEY (id_cliente) REFERENCES dbo.cliente(id_cliente)
);
GO

CREATE TABLE dbo.oportunidad (
    id_oportunidad INT IDENTITY(1,1) NOT NULL,
    numero_oportunidad VARCHAR(30) NOT NULL,
    id_cliente INT NOT NULL,
    id_contacto INT NULL,
    id_tipo_oportunidad INT NOT NULL,
    id_estado_oportunidad INT NOT NULL,
    id_etapa_oportunidad INT NOT NULL,
    id_gestor_comercial INT NOT NULL,
    id_asistente_comercial INT NULL,
    id_gerente_comercial INT NULL,
    nombre_oportunidad VARCHAR(150) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_cierre DATE NULL,
    actividades_abiertas INT NOT NULL CONSTRAINT df_oportunidad_actividades DEFAULT 0,
    porcentaje_avance DECIMAL(5,2) NOT NULL CONSTRAINT df_oportunidad_porcentaje DEFAULT 0,
    potencial VARCHAR(120) NULL,
    cierre_planificado_valor INT NOT NULL,
    cierre_planificado_unidad VARCHAR(20) NOT NULL,
    fecha_cierre_prevista DATE NOT NULL,
    monto_potencial DECIMAL(14,2) NOT NULL CONSTRAINT df_oportunidad_monto_potencial DEFAULT 0,
    monto_ponderado DECIMAL(14,2) NOT NULL CONSTRAINT df_oportunidad_monto_ponderado DEFAULT 0,
    comentario_cierre VARCHAR(500) NULL,
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT df_oportunidad_fecha DEFAULT SYSDATETIME(),
    fecha_actualizacion DATETIME2 NULL,
    CONSTRAINT pk_oportunidad PRIMARY KEY (id_oportunidad),
    CONSTRAINT uq_oportunidad_numero UNIQUE (numero_oportunidad),
    CONSTRAINT fk_oportunidad_cliente_mssql FOREIGN KEY (id_cliente) REFERENCES dbo.cliente(id_cliente),
    CONSTRAINT fk_oportunidad_contacto_mssql FOREIGN KEY (id_contacto) REFERENCES dbo.contacto(id_contacto),
    CONSTRAINT fk_oportunidad_tipo_mssql FOREIGN KEY (id_tipo_oportunidad) REFERENCES dbo.tipo_oportunidad(id_tipo_oportunidad),
    CONSTRAINT fk_oportunidad_estado_mssql FOREIGN KEY (id_estado_oportunidad) REFERENCES dbo.estado_oportunidad(id_estado_oportunidad),
    CONSTRAINT fk_oportunidad_etapa_mssql FOREIGN KEY (id_etapa_oportunidad) REFERENCES dbo.etapa_oportunidad(id_etapa_oportunidad),
    CONSTRAINT fk_oportunidad_gestor_mssql FOREIGN KEY (id_gestor_comercial) REFERENCES dbo.usuario_comercial(id_usuario_comercial),
    CONSTRAINT fk_oportunidad_asistente_mssql FOREIGN KEY (id_asistente_comercial) REFERENCES dbo.usuario_comercial(id_usuario_comercial),
    CONSTRAINT fk_oportunidad_gerente_mssql FOREIGN KEY (id_gerente_comercial) REFERENCES dbo.usuario_comercial(id_usuario_comercial),
    CONSTRAINT chk_oportunidad_porcentaje_mssql CHECK (porcentaje_avance >= 0 AND porcentaje_avance <= 100),
    CONSTRAINT chk_oportunidad_montos_mssql CHECK (monto_potencial >= 0 AND monto_ponderado >= 0),
    CONSTRAINT chk_oportunidad_cierre_planificado_mssql CHECK (cierre_planificado_valor > 0),
    CONSTRAINT chk_oportunidad_unidad_mssql CHECK (cierre_planificado_unidad IN ('Dias', 'Semanas', 'Meses'))
);
GO

CREATE TABLE dbo.actividad (
    id_actividad INT IDENTITY(1,1) NOT NULL,
    numero_actividad VARCHAR(30) NOT NULL,
    id_cliente INT NOT NULL,
    id_contacto INT NULL,
    id_oportunidad INT NULL,
    id_usuario_responsable INT NOT NULL,
    id_tipo_actividad INT NOT NULL,
    id_prioridad_actividad INT NOT NULL,
    id_estado_actividad INT NULL,
    id_finalizacion_actividad INT NULL,
    asunto VARCHAR(150) NOT NULL,
    fecha_actividad DATE NOT NULL,
    hora_inicio TIME NULL,
    hora_final TIME NULL,
    duracion_minutos INT NULL,
    comentario VARCHAR(500) NULL,
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT df_actividad_fecha DEFAULT SYSDATETIME(),
    fecha_actualizacion DATETIME2 NULL,
    CONSTRAINT pk_actividad PRIMARY KEY (id_actividad),
    CONSTRAINT uq_actividad_numero UNIQUE (numero_actividad),
    CONSTRAINT fk_actividad_cliente_mssql FOREIGN KEY (id_cliente) REFERENCES dbo.cliente(id_cliente),
    CONSTRAINT fk_actividad_contacto_mssql FOREIGN KEY (id_contacto) REFERENCES dbo.contacto(id_contacto),
    CONSTRAINT fk_actividad_oportunidad_mssql FOREIGN KEY (id_oportunidad) REFERENCES dbo.oportunidad(id_oportunidad),
    CONSTRAINT fk_actividad_usuario_mssql FOREIGN KEY (id_usuario_responsable) REFERENCES dbo.usuario_comercial(id_usuario_comercial),
    CONSTRAINT fk_actividad_tipo_mssql FOREIGN KEY (id_tipo_actividad) REFERENCES dbo.tipo_actividad(id_tipo_actividad),
    CONSTRAINT fk_actividad_prioridad_mssql FOREIGN KEY (id_prioridad_actividad) REFERENCES dbo.prioridad_actividad(id_prioridad_actividad),
    CONSTRAINT fk_actividad_estado_mssql FOREIGN KEY (id_estado_actividad) REFERENCES dbo.estado_actividad(id_estado_actividad),
    CONSTRAINT fk_actividad_finalizacion_mssql FOREIGN KEY (id_finalizacion_actividad) REFERENCES dbo.finalizacion_actividad(id_finalizacion_actividad),
    CONSTRAINT chk_actividad_duracion_mssql CHECK (duracion_minutos IS NULL OR duracion_minutos >= 0)
);
GO

CREATE TABLE dbo.detalle_reunion (
    id_detalle_reunion INT IDENTITY(1,1) NOT NULL,
    id_actividad INT NOT NULL,
    calle VARCHAR(150) NULL,
    ciudad VARCHAR(100) NULL,
    sala VARCHAR(100) NULL,
    id_estado_actividad INT NULL,
    CONSTRAINT pk_detalle_reunion PRIMARY KEY (id_detalle_reunion),
    CONSTRAINT uq_detalle_reunion_actividad UNIQUE (id_actividad),
    CONSTRAINT fk_detalle_reunion_actividad_mssql FOREIGN KEY (id_actividad) REFERENCES dbo.actividad(id_actividad) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_reunion_estado_mssql FOREIGN KEY (id_estado_actividad) REFERENCES dbo.estado_actividad(id_estado_actividad)
);
GO

-- =========================================================
-- SECCION 3: INDICES
-- =========================================================

CREATE INDEX idx_cliente_tipo ON dbo.cliente(id_tipo_cliente);
CREATE INDEX idx_contacto_cliente ON dbo.contacto(id_cliente);
CREATE INDEX idx_oportunidad_cliente ON dbo.oportunidad(id_cliente);
CREATE INDEX idx_oportunidad_estado ON dbo.oportunidad(id_estado_oportunidad);
CREATE INDEX idx_oportunidad_gestor ON dbo.oportunidad(id_gestor_comercial);
CREATE INDEX idx_oportunidad_fecha_inicio ON dbo.oportunidad(fecha_inicio);
CREATE INDEX idx_actividad_cliente ON dbo.actividad(id_cliente);
CREATE INDEX idx_actividad_oportunidad ON dbo.actividad(id_oportunidad);
CREATE INDEX idx_actividad_responsable ON dbo.actividad(id_usuario_responsable);
CREATE INDEX idx_actividad_fecha ON dbo.actividad(fecha_actividad);
GO

-- =========================================================
-- SECCION 4: FUNCIONES
-- =========================================================

CREATE FUNCTION dbo.fn_calcular_monto_ponderado
(
    @monto_potencial DECIMAL(14,2),
    @porcentaje_avance DECIMAL(5,2)
)
RETURNS DECIMAL(14,2)
AS
BEGIN
    DECLARE @monto_ponderado DECIMAL(14,2);
    SET @monto_ponderado = (@monto_potencial * @porcentaje_avance) / 100;
    RETURN @monto_ponderado;
END;
GO

CREATE FUNCTION dbo.fn_obtener_porcentaje_etapa
(
    @id_etapa_oportunidad INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @porcentaje DECIMAL(5,2);
    SELECT @porcentaje = porcentaje_cierre
    FROM dbo.etapa_oportunidad
    WHERE id_etapa_oportunidad = @id_etapa_oportunidad AND estado = 1;
    RETURN @porcentaje;
END;
GO

CREATE FUNCTION dbo.fn_calcular_duracion_actividad
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

-- =========================================================
-- SECCION 5: PROCEDIMIENTOS DE CLIENTES
-- =========================================================

CREATE PROCEDURE dbo.sp_insertar_cliente
    @id_tipo_cliente INT,
    @codigo_cliente VARCHAR(30),
    @nombre_comercial VARCHAR(150),
    @direccion_empresa VARCHAR(255) = NULL,
    @telefono VARCHAR(25) = NULL,
    @celular VARCHAR(25) = NULL,
    @correo_electronico VARCHAR(120) = NULL,
    @estado BIT = 1,
    @id_cliente_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @msg VARCHAR(500);

    IF NOT EXISTS (SELECT 1 FROM dbo.tipo_cliente WHERE id_tipo_cliente = @id_tipo_cliente AND estado = 1)
    BEGIN
        SET @id_cliente_nuevo = -1;
        RAISERROR('ERROR: El id_tipo_cliente %d no existe o se encuentra inactivo.', 16, 1, @id_tipo_cliente);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.cliente WHERE codigo_cliente = @codigo_cliente)
    BEGIN
        SET @id_cliente_nuevo = -1;
        SET @msg = 'ERROR: Ya existe un cliente con el codigo_cliente: ' + @codigo_cliente;
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM dbo.cliente WHERE LOWER(LTRIM(RTRIM(nombre_comercial))) = LOWER(LTRIM(RTRIM(@nombre_comercial))))
    BEGIN
        SET @id_cliente_nuevo = -1;
        SET @msg = 'ERROR: Ya existe un cliente con el nombre comercial: ' + @nombre_comercial;
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO dbo.cliente (
            id_tipo_cliente,
            codigo_cliente,
            nombre_comercial,
            direccion_empresa,
            telefono,
            celular,
            correo_electronico,
            estado
        )
        VALUES (
            @id_tipo_cliente,
            LTRIM(RTRIM(@codigo_cliente)),
            LTRIM(RTRIM(@nombre_comercial)),
            NULLIF(LTRIM(RTRIM(@direccion_empresa)), ''),
            NULLIF(LTRIM(RTRIM(@telefono)), ''),
            NULLIF(LTRIM(RTRIM(@celular)), ''),
            NULLIF(LOWER(LTRIM(RTRIM(@correo_electronico))), ''),
            @estado
        );
        SET @id_cliente_nuevo = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
        PRINT 'Cliente insertado correctamente. ID generado: ' + CAST(@id_cliente_nuevo AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @id_cliente_nuevo = -1;
        DECLARE @err_msg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev INT = ERROR_SEVERITY();
        DECLARE @err_sta INT = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO

CREATE PROCEDURE dbo.sp_actualizar_cliente
    @id_cliente INT,
    @id_tipo_cliente INT,
    @nombre_comercial VARCHAR(150),
    @direccion_empresa VARCHAR(255) = NULL,
    @telefono VARCHAR(25) = NULL,
    @celular VARCHAR(25) = NULL,
    @correo_electronico VARCHAR(120) = NULL,
    @estado BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @msg VARCHAR(500);

    IF NOT EXISTS (SELECT 1 FROM dbo.cliente WHERE id_cliente = @id_cliente)
    BEGIN
        SET @msg = 'ERROR: No existe un cliente con id_cliente: ' + CAST(@id_cliente AS VARCHAR(10));
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE dbo.cliente
        SET
            id_tipo_cliente = @id_tipo_cliente,
            nombre_comercial = LTRIM(RTRIM(@nombre_comercial)),
            direccion_empresa = NULLIF(LTRIM(RTRIM(@direccion_empresa)), ''),
            telefono = NULLIF(LTRIM(RTRIM(@telefono)), ''),
            celular = NULLIF(LTRIM(RTRIM(@celular)), ''),
            correo_electronico = NULLIF(LOWER(LTRIM(RTRIM(@correo_electronico))), ''),
            estado = @estado
        WHERE id_cliente = @id_cliente;
        COMMIT TRANSACTION;
        PRINT 'Cliente actualizado correctamente. ID: ' + CAST(@id_cliente AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err_msg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev INT = ERROR_SEVERITY();
        DECLARE @err_sta INT = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO

CREATE PROCEDURE dbo.sp_consultar_clientes
    @id_cliente INT = NULL,
    @codigo_cliente VARCHAR(30) = NULL,
    @nombre_comercial VARCHAR(150) = NULL,
    @id_tipo_cliente INT = NULL,
    @estado BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        c.id_cliente,
        c.codigo_cliente,
        c.nombre_comercial,
        tc.nombre_tipo AS tipo_cliente,
        c.direccion_empresa,
        c.telefono,
        c.celular,
        c.correo_electronico,
        CASE WHEN c.estado = 1 THEN 'Activo' ELSE 'Inactivo' END AS estado,
        c.fecha_creacion,
        (SELECT COUNT(*) FROM dbo.contacto ct WHERE ct.id_cliente = c.id_cliente) AS total_contactos
    FROM dbo.cliente c
    INNER JOIN dbo.tipo_cliente tc ON tc.id_tipo_cliente = c.id_tipo_cliente
    WHERE
        (@id_cliente IS NULL OR c.id_cliente = @id_cliente)
        AND (@codigo_cliente IS NULL OR c.codigo_cliente = @codigo_cliente)
        AND (@nombre_comercial IS NULL OR c.nombre_comercial LIKE '%' + @nombre_comercial + '%')
        AND (@id_tipo_cliente IS NULL OR c.id_tipo_cliente = @id_tipo_cliente)
        AND (@estado IS NULL OR c.estado = @estado)
    ORDER BY c.nombre_comercial;
END;
GO

-- =========================================================
-- SECCION 6: PROCEDIMIENTOS DE CONTACTOS
-- =========================================================

CREATE PROCEDURE dbo.sp_insertar_contacto
    @id_cliente INT,
    @nombre_contacto VARCHAR(120),
    @puesto_contacto VARCHAR(100) = NULL,
    @telefono VARCHAR(25) = NULL,
    @celular VARCHAR(25) = NULL,
    @correo_electronico VARCHAR(120) = NULL,
    @estado BIT = 1,
    @id_contacto_nuevo INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @msg VARCHAR(500);

    IF NOT EXISTS (SELECT 1 FROM dbo.cliente WHERE id_cliente = @id_cliente AND estado = 1)
    BEGIN
        SET @id_contacto_nuevo = -1;
        SET @msg = 'ERROR: El id_cliente ' + CAST(@id_cliente AS VARCHAR(10)) + ' no existe o se encuentra inactivo.';
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO dbo.contacto (
            id_cliente,
            nombre_contacto,
            puesto_contacto,
            telefono,
            celular,
            correo_electronico,
            estado
        )
        VALUES (
            @id_cliente,
            LTRIM(RTRIM(@nombre_contacto)),
            NULLIF(LTRIM(RTRIM(@puesto_contacto)), ''),
            NULLIF(LTRIM(RTRIM(@telefono)), ''),
            NULLIF(LTRIM(RTRIM(@celular)), ''),
            NULLIF(LOWER(LTRIM(RTRIM(@correo_electronico))), ''),
            @estado
        );
        SET @id_contacto_nuevo = SCOPE_IDENTITY();
        COMMIT TRANSACTION;
        PRINT 'Contacto insertado correctamente. ID generado: ' + CAST(@id_contacto_nuevo AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SET @id_contacto_nuevo = -1;
        DECLARE @err_msg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev INT = ERROR_SEVERITY();
        DECLARE @err_sta INT = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO

CREATE PROCEDURE dbo.sp_actualizar_contacto
    @id_contacto INT,
    @id_cliente INT,
    @nombre_contacto VARCHAR(120),
    @puesto_contacto VARCHAR(100) = NULL,
    @telefono VARCHAR(25) = NULL,
    @celular VARCHAR(25) = NULL,
    @correo_electronico VARCHAR(120) = NULL,
    @estado BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @msg VARCHAR(500);

    IF NOT EXISTS (SELECT 1 FROM dbo.contacto WHERE id_contacto = @id_contacto)
    BEGIN
        SET @msg = 'ERROR: No existe un contacto con id_contacto: ' + CAST(@id_contacto AS VARCHAR(10));
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE dbo.contacto
        SET
            id_cliente = @id_cliente,
            nombre_contacto = LTRIM(RTRIM(@nombre_contacto)),
            puesto_contacto = NULLIF(LTRIM(RTRIM(@puesto_contacto)), ''),
            telefono = NULLIF(LTRIM(RTRIM(@telefono)), ''),
            celular = NULLIF(LTRIM(RTRIM(@celular)), ''),
            correo_electronico = NULLIF(LOWER(LTRIM(RTRIM(@correo_electronico))), ''),
            estado = @estado
        WHERE id_contacto = @id_contacto;
        COMMIT TRANSACTION;
        PRINT 'Contacto actualizado correctamente. ID: ' + CAST(@id_contacto AS VARCHAR(10));
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err_msg NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev INT = ERROR_SEVERITY();
        DECLARE @err_sta INT = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO

CREATE PROCEDURE dbo.sp_consultar_contactos_por_cliente
    @id_cliente INT,
    @estado BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @msg VARCHAR(500);

    IF NOT EXISTS (SELECT 1 FROM dbo.cliente WHERE id_cliente = @id_cliente)
    BEGIN
        SET @msg = 'ERROR: No existe un cliente con id_cliente: ' + CAST(@id_cliente AS VARCHAR(10));
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    SELECT
        ct.id_contacto,
        ct.id_cliente,
        c.codigo_cliente,
        c.nombre_comercial AS cliente,
        ct.nombre_contacto,
        ct.puesto_contacto,
        ct.telefono,
        ct.celular,
        ct.correo_electronico,
        CASE WHEN ct.estado = 1 THEN 'Activo' ELSE 'Inactivo' END AS estado,
        ct.fecha_creacion
    FROM dbo.contacto ct
    INNER JOIN dbo.cliente c ON c.id_cliente = ct.id_cliente
    WHERE ct.id_cliente = @id_cliente AND (@estado IS NULL OR ct.estado = @estado)
    ORDER BY ct.nombre_contacto;
END;
GO

-- =========================================================
-- SECCION 7: PROCEDIMIENTOS DE OPORTUNIDADES
-- =========================================================

CREATE PROCEDURE dbo.sp_crear_oportunidad
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

    SELECT @id_estado_abierto = id_estado_oportunidad FROM dbo.estado_oportunidad WHERE nombre_estado = 'Abierto';
    SET @porcentaje_avance = dbo.fn_obtener_porcentaje_etapa(@id_etapa_oportunidad);
    SET @monto_ponderado = dbo.fn_calcular_monto_ponderado(@monto_potencial, @porcentaje_avance);

    IF @cierre_planificado_unidad = 'Dias'
        SET @fecha_cierre_prevista = DATEADD(DAY, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE IF @cierre_planificado_unidad = 'Semanas'
        SET @fecha_cierre_prevista = DATEADD(WEEK, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE IF @cierre_planificado_unidad = 'Meses'
        SET @fecha_cierre_prevista = DATEADD(MONTH, @cierre_planificado_valor, CAST(GETDATE() AS DATE));
    ELSE
        THROW 50001, 'La unidad de cierre planificado debe ser Dias, Semanas o Meses.', 1;

    INSERT INTO dbo.oportunidad (
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
    VALUES (
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

CREATE PROCEDURE dbo.sp_actualizar_oportunidad
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

    SELECT @id_etapa_oportunidad = id_etapa_oportunidad FROM dbo.oportunidad WHERE id_oportunidad = @id_oportunidad;
    SET @porcentaje_avance = dbo.fn_obtener_porcentaje_etapa(@id_etapa_oportunidad);
    SET @monto_ponderado = dbo.fn_calcular_monto_ponderado(@monto_potencial, @porcentaje_avance);

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

CREATE PROCEDURE dbo.sp_cambiar_etapa_oportunidad
    @id_oportunidad INT,
    @id_etapa_oportunidad INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @porcentaje_avance DECIMAL(5,2);
    DECLARE @monto_potencial DECIMAL(14,2);
    DECLARE @monto_ponderado DECIMAL(14,2);

    SET @porcentaje_avance = dbo.fn_obtener_porcentaje_etapa(@id_etapa_oportunidad);
    SELECT @monto_potencial = monto_potencial FROM dbo.oportunidad WHERE id_oportunidad = @id_oportunidad;
    SET @monto_ponderado = dbo.fn_calcular_monto_ponderado(@monto_potencial, @porcentaje_avance);

    UPDATE dbo.oportunidad
    SET id_etapa_oportunidad = @id_etapa_oportunidad,
        porcentaje_avance = @porcentaje_avance,
        monto_ponderado = @monto_ponderado,
        fecha_actualizacion = GETDATE()
    WHERE id_oportunidad = @id_oportunidad;
END;
GO

CREATE PROCEDURE dbo.sp_cerrar_oportunidad
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

-- =========================================================
-- SECCION 8: PROCEDIMIENTOS DE ACTIVIDADES
-- =========================================================

CREATE PROCEDURE dbo.sp_registrar_actividad
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
        THROW 50001, 'La hora final debe ser mayor que la hora de inicio.', 1;

    SET @duracion_minutos = CASE WHEN @hora_final IS NOT NULL THEN dbo.fn_calcular_duracion_actividad(@hora_inicio, @hora_final) ELSE NULL END;

    INSERT INTO actividad (
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
        fecha_actividad,
        hora_inicio,
        hora_final,
        duracion_minutos,
        comentario,
        fecha_creacion,
        fecha_actualizacion
    )
    VALUES (
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

CREATE PROCEDURE dbo.sp_actualizar_actividad
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
        THROW 50002, 'La actividad indicada no existe.', 1;

    IF @hora_final IS NOT NULL AND @hora_final <= @hora_inicio
        THROW 50003, 'La hora final debe ser mayor que la hora de inicio.', 1;

    SET @duracion_minutos = CASE WHEN @hora_final IS NOT NULL THEN dbo.fn_calcular_duracion_actividad(@hora_inicio, @hora_final) ELSE NULL END;

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

CREATE PROCEDURE dbo.sp_cerrar_actividad
(
    @id_actividad INT,
    @comentario_cierre VARCHAR(500)
)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id_finalizacion_cerrado INT;

    SELECT @id_finalizacion_cerrado = id_finalizacion_actividad FROM finalizacion_actividad WHERE nombre_finalizacion = 'Cerrado';

    IF @id_finalizacion_cerrado IS NULL
        THROW 50004, 'No existe la finalización Cerrado en la tabla finalizacion_actividad.', 1;

    UPDATE actividad
    SET
        id_finalizacion_actividad = @id_finalizacion_cerrado,
        comentario = CONCAT(ISNULL(comentario, ''), ' | Cierre: ', @comentario_cierre),
        fecha_actualizacion = GETDATE()
    WHERE id_actividad = @id_actividad;
END;
GO

CREATE PROCEDURE dbo.sp_consultar_actividades_por_cliente
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
    INNER JOIN cliente c ON a.id_cliente = c.id_cliente
    LEFT JOIN contacto co ON a.id_contacto = co.id_contacto
    INNER JOIN tipo_actividad ta ON a.id_tipo_actividad = ta.id_tipo_actividad
    INNER JOIN prioridad_actividad pa ON a.id_prioridad_actividad = pa.id_prioridad_actividad
    LEFT JOIN estado_actividad ea ON a.id_estado_actividad = ea.id_estado_actividad
    LEFT JOIN finalizacion_actividad fa ON a.id_finalizacion_actividad = fa.id_finalizacion_actividad
    WHERE a.id_cliente = @id_cliente
    ORDER BY a.fecha_actividad DESC, a.hora_inicio DESC;
END;
GO

CREATE PROCEDURE dbo.sp_consultar_actividades_por_oportunidad
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
    INNER JOIN oportunidad o ON a.id_oportunidad = o.id_oportunidad
    INNER JOIN cliente c ON a.id_cliente = c.id_cliente
    LEFT JOIN contacto co ON a.id_contacto = co.id_contacto
    INNER JOIN tipo_actividad ta ON a.id_tipo_actividad = ta.id_tipo_actividad
    INNER JOIN prioridad_actividad pa ON a.id_prioridad_actividad = pa.id_prioridad_actividad
    LEFT JOIN estado_actividad ea ON a.id_estado_actividad = ea.id_estado_actividad
    WHERE a.id_oportunidad = @id_oportunidad
    ORDER BY a.fecha_actividad DESC, a.hora_inicio DESC;
END;
GO

-- =========================================================
-- SECCION 9: TRIGGERS
-- =========================================================

CREATE TRIGGER dbo.trg_validar_cierre_oportunidad
ON dbo.oportunidad
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.estado_oportunidad eo ON i.id_estado_oportunidad = eo.id_estado_oportunidad
        WHERE eo.nombre_estado IN ('Ganado', 'Perdida') AND i.porcentaje_avance <> 100
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51001, 'La oportunidad solo puede cerrarse como ganada o perdida si el porcentaje de avance es 100%.', 1;
    END
END;
GO

CREATE TRIGGER dbo.trg_exigir_comentario_cierre
ON dbo.oportunidad
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.estado_oportunidad eo ON i.id_estado_oportunidad = eo.id_estado_oportunidad
        WHERE eo.nombre_estado IN ('Ganado', 'Perdida') AND (i.comentario_cierre IS NULL OR LTRIM(RTRIM(i.comentario_cierre)) = '')
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51002, 'Debe ingresar un comentario cuando la oportunidad se marque como ganada o perdida.', 1;
    END
END;
GO

CREATE TRIGGER dbo.trg_validar_tipo_actividad
ON actividad
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN tipo_actividad ta ON i.id_tipo_actividad = ta.id_tipo_actividad
        WHERE ta.nombre_tipo = 'Tarea' AND i.id_estado_actividad IS NULL
    )
        THROW 50005, 'Las actividades de tipo Tarea deben tener estado.', 1;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN tipo_actividad ta ON i.id_tipo_actividad = ta.id_tipo_actividad
        WHERE ta.nombre_tipo = 'Nota' AND (i.fecha_actividad IS NULL OR i.hora_inicio IS NULL OR i.id_prioridad_actividad IS NULL)
    )
        THROW 50006, 'Las actividades de tipo Nota deben tener fecha, hora y prioridad.', 1;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.hora_final IS NOT NULL AND i.hora_inicio IS NOT NULL AND i.hora_final <= i.hora_inicio
    )
        THROW 50007, 'La hora final debe ser mayor que la hora de inicio.', 1;
END;
GO

-- =========================================================
-- SECCION 10: PROCEDIMIENTOS DE REPORTES
-- =========================================================

CREATE PROCEDURE dbo.sp_informe_oportunidades_por_fecha
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
    INNER JOIN cliente c ON o.id_cliente = c.id_cliente
    INNER JOIN estado_oportunidad eo ON o.id_estado_oportunidad = eo.id_estado_oportunidad
    INNER JOIN etapa_oportunidad et ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
    WHERE o.fecha_inicio BETWEEN @fecha_inicio AND @fecha_fin
    ORDER BY o.fecha_inicio;
END;
GO

CREATE PROCEDURE dbo.sp_informe_oportunidades_por_gestor
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
    INNER JOIN cliente c ON o.id_cliente = c.id_cliente
    INNER JOIN usuario_comercial u ON o.id_gestor_comercial = u.id_usuario_comercial
    INNER JOIN estado_oportunidad eo ON o.id_estado_oportunidad = eo.id_estado_oportunidad
    INNER JOIN etapa_oportunidad et ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
    WHERE o.id_gestor_comercial = @id_gestor_comercial
    ORDER BY o.fecha_inicio DESC;
END;
GO

CREATE PROCEDURE dbo.sp_informe_oportunidades_ganadas_perdidas
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
    INNER JOIN cliente c ON o.id_cliente = c.id_cliente
    INNER JOIN estado_oportunidad eo ON o.id_estado_oportunidad = eo.id_estado_oportunidad
    INNER JOIN etapa_oportunidad et ON o.id_etapa_oportunidad = et.id_etapa_oportunidad
    WHERE eo.nombre_estado IN ('Ganado', 'Perdida')
    ORDER BY o.fecha_cierre DESC;
END;
GO

-- =========================================================
-- SECCION 11: DATOS INICIALES
-- =========================================================

INSERT INTO dbo.rol_usuario (nombre_rol, descripcion) VALUES
('Gestor Comercial', 'Responsable del seguimiento comercial'),
('Asistente Comercial', 'Apoya al area comercial'),
('Gerente Comercial', 'Responsable gerencial del area comercial'),
('Gerente General', 'Usuario de gerencia general para consulta y reportes');
GO

INSERT INTO dbo.tipo_cliente (nombre_tipo, descripcion) VALUES
('Cliente Potencial', 'Cliente en proceso de negociacion'),
('Cliente Final', 'Cliente confirmado o activo');
GO

INSERT INTO dbo.tipo_oportunidad (nombre_tipo, descripcion) VALUES
('Venta', 'Oportunidad relacionada con una venta'),
('Compra', 'Oportunidad relacionada con una compra');
GO

INSERT INTO dbo.estado_oportunidad (nombre_estado, descripcion) VALUES
('Abierto', 'La oportunidad se encuentra en proceso'),
('Ganado', 'La oportunidad fue cerrada de forma exitosa'),
('Perdida', 'La oportunidad fue cerrada sin negociacion exitosa');
GO

INSERT INTO dbo.etapa_oportunidad (nombre_etapa, porcentaje_cierre, orden_etapa) VALUES
('Toma de Decision', 20.00, 1),
('Proceso Toma de Decision', 30.00, 2),
('Analisis de Proyecto', 50.00, 3),
('Presentacion de Cotizacion', 80.00, 4),
('Validacion de Cotizacion', 95.00, 5),
('Acuerdo de Cierre', 100.00, 6);
GO

INSERT INTO dbo.tipo_actividad (nombre_tipo, descripcion) VALUES
('Llamada Telefonica', 'Contacto telefonico con el cliente'),
('Reunion', 'Reunion con el cliente'),
('Tarea', 'Actividad interna asignada'),
('Nota', 'Registro de una nota informativa'),
('Agendar Visita', 'Actividad para programar visita'),
('Proyecto Nuevo', 'Seguimiento a un proyecto nuevo'),
('Visita a Cliente', 'Visita presencial al cliente'),
('Reclamo de Cliente', 'Seguimiento a reclamo presentado por el cliente');
GO

INSERT INTO dbo.prioridad_actividad (nombre_prioridad, descripcion) VALUES
('Normal', 'Prioridad normal'),
('Alto', 'Prioridad alta'),
('Bajo', 'Prioridad baja');
GO

INSERT INTO dbo.estado_actividad (nombre_estado, descripcion) VALUES
('En Proceso', 'Actividad en proceso'),
('En Espera', 'Actividad en espera'),
('Concluido', 'Actividad concluida'),
('No Iniciado', 'Actividad no iniciada'),
('No Concluido', 'Actividad no concluida');
GO

INSERT INTO dbo.finalizacion_actividad (nombre_finalizacion, descripcion) VALUES
('Inactivo', 'Actividad marcada como inactiva'),
('Cerrado', 'Actividad cerrada');
GO

-- =========================================================
-- FIN DEL SCRIPT UNIFICADO
-- =========================================================
PRINT '✓ Base de datos InnovacionCRM inicializada correctamente con todos los componentes';
