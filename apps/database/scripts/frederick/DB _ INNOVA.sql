-- =========================================================
-- Proyecto Final Base de Datos II
-- Empresa: Innovacion, S.A.
-- Sistema: Seguimiento Comercial / CRM
-- Motor: Microsoft SQL Server
-- Contenido: Estructura de base de datos, tablas, catalogos,
--            llaves primarias y llaves foraneas.
-- Nota: Este script no incluye procedimientos almacenados,
--       funciones ni triggers.
-- =========================================================

IF DB_ID('InnovacionCRM') IS NULL
BEGIN
    CREATE DATABASE InnovacionCRM;
END;
GO

USE InnovacionCRM;
GO

-- =========================================================
-- LIMPIEZA DE TABLAS
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
-- CATALOGOS GENERALES
-- =========================================================

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

CREATE TABLE dbo.rol_usuario (
    id_rol_usuario INT IDENTITY(1,1) NOT NULL,
    nombre_rol VARCHAR(80) NOT NULL,
    descripcion VARCHAR(255) NULL,
    estado BIT NOT NULL CONSTRAINT df_rol_usuario_estado DEFAULT 1,
    CONSTRAINT pk_rol_usuario PRIMARY KEY (id_rol_usuario),
    CONSTRAINT uq_rol_usuario_nombre UNIQUE (nombre_rol)
);
GO

-- =========================================================
-- TABLAS PRINCIPALES
-- =========================================================

CREATE TABLE dbo.usuario_comercial (
    id_usuario_comercial INT IDENTITY(1,1) NOT NULL,
    id_rol_usuario INT NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    telefono VARCHAR(25) NULL,
    estado BIT NOT NULL CONSTRAINT df_usuario_comercial_estado DEFAULT 1,
    fecha_creacion DATETIME2 NOT NULL CONSTRAINT df_usuario_fecha DEFAULT SYSDATETIME(),
    CONSTRAINT pk_usuario_comercial PRIMARY KEY (id_usuario_comercial),
    CONSTRAINT uq_usuario_correo UNIQUE (correo),
    CONSTRAINT fk_usuario_rol_mssql FOREIGN KEY (id_rol_usuario)
        REFERENCES dbo.rol_usuario(id_rol_usuario)
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
    CONSTRAINT fk_cliente_tipo_mssql FOREIGN KEY (id_tipo_cliente)
        REFERENCES dbo.tipo_cliente(id_tipo_cliente)
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
    CONSTRAINT fk_contacto_cliente_mssql FOREIGN KEY (id_cliente)
        REFERENCES dbo.cliente(id_cliente)
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
    CONSTRAINT fk_oportunidad_cliente_mssql FOREIGN KEY (id_cliente)
        REFERENCES dbo.cliente(id_cliente),
    CONSTRAINT fk_oportunidad_contacto_mssql FOREIGN KEY (id_contacto)
        REFERENCES dbo.contacto(id_contacto),
    CONSTRAINT fk_oportunidad_tipo_mssql FOREIGN KEY (id_tipo_oportunidad)
        REFERENCES dbo.tipo_oportunidad(id_tipo_oportunidad),
    CONSTRAINT fk_oportunidad_estado_mssql FOREIGN KEY (id_estado_oportunidad)
        REFERENCES dbo.estado_oportunidad(id_estado_oportunidad),
    CONSTRAINT fk_oportunidad_etapa_mssql FOREIGN KEY (id_etapa_oportunidad)
        REFERENCES dbo.etapa_oportunidad(id_etapa_oportunidad),
    CONSTRAINT fk_oportunidad_gestor_mssql FOREIGN KEY (id_gestor_comercial)
        REFERENCES dbo.usuario_comercial(id_usuario_comercial),
    CONSTRAINT fk_oportunidad_asistente_mssql FOREIGN KEY (id_asistente_comercial)
        REFERENCES dbo.usuario_comercial(id_usuario_comercial),
    CONSTRAINT fk_oportunidad_gerente_mssql FOREIGN KEY (id_gerente_comercial)
        REFERENCES dbo.usuario_comercial(id_usuario_comercial),
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
    CONSTRAINT fk_actividad_cliente_mssql FOREIGN KEY (id_cliente)
        REFERENCES dbo.cliente(id_cliente),
    CONSTRAINT fk_actividad_contacto_mssql FOREIGN KEY (id_contacto)
        REFERENCES dbo.contacto(id_contacto),
    CONSTRAINT fk_actividad_oportunidad_mssql FOREIGN KEY (id_oportunidad)
        REFERENCES dbo.oportunidad(id_oportunidad),
    CONSTRAINT fk_actividad_usuario_mssql FOREIGN KEY (id_usuario_responsable)
        REFERENCES dbo.usuario_comercial(id_usuario_comercial),
    CONSTRAINT fk_actividad_tipo_mssql FOREIGN KEY (id_tipo_actividad)
        REFERENCES dbo.tipo_actividad(id_tipo_actividad),
    CONSTRAINT fk_actividad_prioridad_mssql FOREIGN KEY (id_prioridad_actividad)
        REFERENCES dbo.prioridad_actividad(id_prioridad_actividad),
    CONSTRAINT fk_actividad_estado_mssql FOREIGN KEY (id_estado_actividad)
        REFERENCES dbo.estado_actividad(id_estado_actividad),
    CONSTRAINT fk_actividad_finalizacion_mssql FOREIGN KEY (id_finalizacion_actividad)
        REFERENCES dbo.finalizacion_actividad(id_finalizacion_actividad),
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
    CONSTRAINT fk_detalle_reunion_actividad_mssql FOREIGN KEY (id_actividad)
        REFERENCES dbo.actividad(id_actividad)
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_reunion_estado_mssql FOREIGN KEY (id_estado_actividad)
        REFERENCES dbo.estado_actividad(id_estado_actividad)
);
GO

-- =========================================================
-- INDICES SUGERIDOS
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
-- DATOS INICIALES DE CATALOGOS
-- =========================================================

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

INSERT INTO dbo.rol_usuario (nombre_rol, descripcion) VALUES
('Gestor Comercial', 'Responsable del seguimiento comercial'),
('Asistente Comercial', 'Apoya al area comercial'),
('Gerente Comercial', 'Responsable gerencial del area comercial'),
('Gerente General', 'Usuario de gerencia general para consulta y reportes');
GO

-- =========================================================
-- FIN DEL SCRIPT SQL SERVER
-- =========================================================
