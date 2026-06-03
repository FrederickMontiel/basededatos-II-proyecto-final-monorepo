-- =========================================================
-- Proyecto Final Base de Datos II
-- Empresa: Innovacion, S.A.
-- Sistema: Seguimiento Comercial / CRM
-- Motor: Microsoft SQL Server
-- Contenido: Procedimientos Almacenados - Clientes y Contactos
-- Integrante: [TU NOMBRE AQUI]
-- =========================================================


-- =========================================================
-- SECCION 1: PROCEDIMIENTOS ALMACENADOS PARA CLIENTES
-- =========================================================

-- ---------------------------------------------------------
-- SP 1.1: INSERTAR CLIENTE
-- Valida duplicados por correo, telefono y nombre_comercial
-- ---------------------------------------------------------
CREATE PROCEDURE dbo.sp_insertar_cliente
    @id_tipo_cliente      INT,
    @codigo_cliente       VARCHAR(30),
    @nombre_comercial     VARCHAR(150),
    @direccion_empresa    VARCHAR(255) = NULL,
    @telefono             VARCHAR(25)  = NULL,
    @celular              VARCHAR(25)  = NULL,
    @correo_electronico   VARCHAR(120) = NULL,
    @estado               BIT          = 1,
    @id_cliente_nuevo     INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @msg VARCHAR(500);

    -- Validar tipo de cliente existe y esta activo
    IF NOT EXISTS (
        SELECT 1 FROM dbo.tipo_cliente
        WHERE id_tipo_cliente = @id_tipo_cliente AND estado = 1
    )
    BEGIN
        SET @id_cliente_nuevo = -1;
        RAISERROR('ERROR: El id_tipo_cliente %d no existe o se encuentra inactivo.', 16, 1, @id_tipo_cliente);
        RETURN;
    END

    -- Validar codigo_cliente duplicado
    IF EXISTS (
        SELECT 1 FROM dbo.cliente
        WHERE codigo_cliente = @codigo_cliente
    )
    BEGIN
        SET @id_cliente_nuevo = -1;
        SET @msg = 'ERROR: Ya existe un cliente con el codigo_cliente: ' + @codigo_cliente;
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar nombre_comercial duplicado
    IF EXISTS (
        SELECT 1 FROM dbo.cliente
        WHERE LOWER(LTRIM(RTRIM(nombre_comercial))) = LOWER(LTRIM(RTRIM(@nombre_comercial)))
    )
    BEGIN
        SET @id_cliente_nuevo = -1;
        SET @msg = 'ERROR: Ya existe un cliente con el nombre comercial: ' + @nombre_comercial;
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar correo duplicado (solo si se proporciona)
    IF @correo_electronico IS NOT NULL AND LTRIM(RTRIM(@correo_electronico)) <> ''
    BEGIN
        IF EXISTS (
            SELECT 1 FROM dbo.cliente
            WHERE LOWER(correo_electronico) = LOWER(LTRIM(RTRIM(@correo_electronico)))
        )
        BEGIN
            SET @id_cliente_nuevo = -1;
            SET @msg = 'ERROR: Ya existe un cliente registrado con el correo: ' + @correo_electronico;
            RAISERROR(@msg, 16, 1);
            RETURN;
        END
    END

    -- Validar telefono duplicado (solo si se proporciona)
    IF @telefono IS NOT NULL AND LTRIM(RTRIM(@telefono)) <> ''
    BEGIN
        IF EXISTS (
            SELECT 1 FROM dbo.cliente
            WHERE telefono = LTRIM(RTRIM(@telefono))
        )
        BEGIN
            SET @id_cliente_nuevo = -1;
            SET @msg = 'ERROR: Ya existe un cliente registrado con el telefono: ' + @telefono;
            RAISERROR(@msg, 16, 1);
            RETURN;
        END
    END

    -- Insertar cliente
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
        DECLARE @err_msg  NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev  INT            = ERROR_SEVERITY();
        DECLARE @err_sta  INT            = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO


-- ---------------------------------------------------------
-- SP 1.2: ACTUALIZAR CLIENTE
-- Valida duplicados excluyendo el propio registro
-- ---------------------------------------------------------
CREATE PROCEDURE dbo.sp_actualizar_cliente
    @id_cliente           INT,
    @id_tipo_cliente      INT,
    @nombre_comercial     VARCHAR(150),
    @direccion_empresa    VARCHAR(255) = NULL,
    @telefono             VARCHAR(25)  = NULL,
    @celular              VARCHAR(25)  = NULL,
    @correo_electronico   VARCHAR(120) = NULL,
    @estado               BIT          = 1
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @msg VARCHAR(500);

    -- Verificar que el cliente existe
    IF NOT EXISTS (
        SELECT 1 FROM dbo.cliente WHERE id_cliente = @id_cliente
    )
    BEGIN
        SET @msg = 'ERROR: No existe un cliente con id_cliente: ' + CAST(@id_cliente AS VARCHAR(10));
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar tipo de cliente activo
    IF NOT EXISTS (
        SELECT 1 FROM dbo.tipo_cliente
        WHERE id_tipo_cliente = @id_tipo_cliente AND estado = 1
    )
    BEGIN
        RAISERROR('ERROR: El id_tipo_cliente %d no existe o se encuentra inactivo.', 16, 1, @id_tipo_cliente);
        RETURN;
    END

    -- Validar nombre_comercial no usado por otro cliente
    IF EXISTS (
        SELECT 1 FROM dbo.cliente
        WHERE LOWER(LTRIM(RTRIM(nombre_comercial))) = LOWER(LTRIM(RTRIM(@nombre_comercial)))
          AND id_cliente <> @id_cliente
    )
    BEGIN
        SET @msg = 'ERROR: Otro cliente ya tiene el nombre comercial: ' + @nombre_comercial;
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar correo no usado por otro cliente
    IF @correo_electronico IS NOT NULL AND LTRIM(RTRIM(@correo_electronico)) <> ''
    BEGIN
        IF EXISTS (
            SELECT 1 FROM dbo.cliente
            WHERE LOWER(correo_electronico) = LOWER(LTRIM(RTRIM(@correo_electronico)))
              AND id_cliente <> @id_cliente
        )
        BEGIN
            SET @msg = 'ERROR: Otro cliente ya esta registrado con el correo: ' + @correo_electronico;
            RAISERROR(@msg, 16, 1);
            RETURN;
        END
    END

    -- Validar telefono no usado por otro cliente
    IF @telefono IS NOT NULL AND LTRIM(RTRIM(@telefono)) <> ''
    BEGIN
        IF EXISTS (
            SELECT 1 FROM dbo.cliente
            WHERE telefono = LTRIM(RTRIM(@telefono))
              AND id_cliente <> @id_cliente
        )
        BEGIN
            SET @msg = 'ERROR: Otro cliente ya esta registrado con el telefono: ' + @telefono;
            RAISERROR(@msg, 16, 1);
            RETURN;
        END
    END

    -- Actualizar registro
    BEGIN TRY
        BEGIN TRANSACTION;

            UPDATE dbo.cliente
            SET
                id_tipo_cliente    = @id_tipo_cliente,
                nombre_comercial   = LTRIM(RTRIM(@nombre_comercial)),
                direccion_empresa  = NULLIF(LTRIM(RTRIM(@direccion_empresa)), ''),
                telefono           = NULLIF(LTRIM(RTRIM(@telefono)), ''),
                celular            = NULLIF(LTRIM(RTRIM(@celular)), ''),
                correo_electronico = NULLIF(LOWER(LTRIM(RTRIM(@correo_electronico))), ''),
                estado             = @estado
            WHERE id_cliente = @id_cliente;

        COMMIT TRANSACTION;

        PRINT 'Cliente actualizado correctamente. ID: ' + CAST(@id_cliente AS VARCHAR(10));

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err_msg  NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev  INT            = ERROR_SEVERITY();
        DECLARE @err_sta  INT            = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO


-- ---------------------------------------------------------
-- SP 1.3: CONSULTAR CLIENTES
-- Todos los parametros son opcionales (NULL = sin filtro)
-- ---------------------------------------------------------
CREATE PROCEDURE dbo.sp_consultar_clientes
    @id_cliente         INT          = NULL,
    @codigo_cliente     VARCHAR(30)  = NULL,
    @nombre_comercial   VARCHAR(150) = NULL,
    @id_tipo_cliente    INT          = NULL,
    @estado             BIT          = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.id_cliente,
        c.codigo_cliente,
        c.nombre_comercial,
        tc.nombre_tipo          AS tipo_cliente,
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
        (@id_cliente       IS NULL OR c.id_cliente      = @id_cliente)
        AND (@codigo_cliente  IS NULL OR c.codigo_cliente  = @codigo_cliente)
        AND (@nombre_comercial IS NULL OR c.nombre_comercial LIKE '%' + @nombre_comercial + '%')
        AND (@id_tipo_cliente  IS NULL OR c.id_tipo_cliente = @id_tipo_cliente)
        AND (@estado           IS NULL OR c.estado          = @estado)
    ORDER BY c.nombre_comercial;
END;
GO


-- =========================================================
-- SECCION 2: PROCEDIMIENTOS ALMACENADOS PARA CONTACTOS
-- =========================================================

-- ---------------------------------------------------------
-- SP 2.1: INSERTAR CONTACTO
-- Valida que el cliente exista y este activo
-- ---------------------------------------------------------
CREATE PROCEDURE dbo.sp_insertar_contacto
    @id_cliente           INT,
    @nombre_contacto      VARCHAR(120),
    @puesto_contacto      VARCHAR(100) = NULL,
    @telefono             VARCHAR(25)  = NULL,
    @celular              VARCHAR(25)  = NULL,
    @correo_electronico   VARCHAR(120) = NULL,
    @estado               BIT          = 1,
    @id_contacto_nuevo    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @msg VARCHAR(500);

    -- Validar que el cliente existe y esta activo
    IF NOT EXISTS (
        SELECT 1 FROM dbo.cliente
        WHERE id_cliente = @id_cliente AND estado = 1
    )
    BEGIN
        SET @id_contacto_nuevo = -1;
        SET @msg = 'ERROR: El id_cliente ' + CAST(@id_cliente AS VARCHAR(10))
                 + ' no existe o se encuentra inactivo. No se puede crear el contacto.';
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar nombre de contacto no duplicado en el mismo cliente
    IF EXISTS (
        SELECT 1 FROM dbo.contacto
        WHERE id_cliente = @id_cliente
          AND LOWER(LTRIM(RTRIM(nombre_contacto))) = LOWER(LTRIM(RTRIM(@nombre_contacto)))
    )
    BEGIN
        SET @id_contacto_nuevo = -1;
        SET @msg = 'ERROR: El cliente ya tiene un contacto registrado con el nombre: ' + @nombre_contacto;
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar correo no duplicado globalmente (si se proporciona)
    IF @correo_electronico IS NOT NULL AND LTRIM(RTRIM(@correo_electronico)) <> ''
    BEGIN
        IF EXISTS (
            SELECT 1 FROM dbo.contacto
            WHERE LOWER(correo_electronico) = LOWER(LTRIM(RTRIM(@correo_electronico)))
        )
        BEGIN
            SET @id_contacto_nuevo = -1;
            SET @msg = 'ERROR: Ya existe un contacto con el correo: ' + @correo_electronico;
            RAISERROR(@msg, 16, 1);
            RETURN;
        END
    END

    -- Insertar contacto
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
        DECLARE @err_msg  NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev  INT            = ERROR_SEVERITY();
        DECLARE @err_sta  INT            = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO


-- ---------------------------------------------------------
-- SP 2.2: ACTUALIZAR CONTACTO
-- Valida que el cliente destino exista, y evita duplicados
-- ---------------------------------------------------------
CREATE PROCEDURE dbo.sp_actualizar_contacto
    @id_contacto          INT,
    @id_cliente           INT,
    @nombre_contacto      VARCHAR(120),
    @puesto_contacto      VARCHAR(100) = NULL,
    @telefono             VARCHAR(25)  = NULL,
    @celular              VARCHAR(25)  = NULL,
    @correo_electronico   VARCHAR(120) = NULL,
    @estado               BIT          = 1
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @msg VARCHAR(500);

    -- Verificar que el contacto existe
    IF NOT EXISTS (
        SELECT 1 FROM dbo.contacto WHERE id_contacto = @id_contacto
    )
    BEGIN
        SET @msg = 'ERROR: No existe un contacto con id_contacto: ' + CAST(@id_contacto AS VARCHAR(10));
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar que el cliente existe y esta activo
    IF NOT EXISTS (
        SELECT 1 FROM dbo.cliente
        WHERE id_cliente = @id_cliente AND estado = 1
    )
    BEGIN
        SET @msg = 'ERROR: El id_cliente ' + CAST(@id_cliente AS VARCHAR(10))
                 + ' no existe o se encuentra inactivo.';
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar nombre no duplicado en el mismo cliente (excluye propio)
    IF EXISTS (
        SELECT 1 FROM dbo.contacto
        WHERE id_cliente = @id_cliente
          AND LOWER(LTRIM(RTRIM(nombre_contacto))) = LOWER(LTRIM(RTRIM(@nombre_contacto)))
          AND id_contacto <> @id_contacto
    )
    BEGIN
        SET @msg = 'ERROR: El cliente ya tiene otro contacto con el nombre: ' + @nombre_contacto;
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Validar correo no duplicado (excluye propio)
    IF @correo_electronico IS NOT NULL AND LTRIM(RTRIM(@correo_electronico)) <> ''
    BEGIN
        IF EXISTS (
            SELECT 1 FROM dbo.contacto
            WHERE LOWER(correo_electronico) = LOWER(LTRIM(RTRIM(@correo_electronico)))
              AND id_contacto <> @id_contacto
        )
        BEGIN
            SET @msg = 'ERROR: Otro contacto ya esta registrado con el correo: ' + @correo_electronico;
            RAISERROR(@msg, 16, 1);
            RETURN;
        END
    END

    -- Actualizar registro
    BEGIN TRY
        BEGIN TRANSACTION;

            UPDATE dbo.contacto
            SET
                id_cliente          = @id_cliente,
                nombre_contacto     = LTRIM(RTRIM(@nombre_contacto)),
                puesto_contacto     = NULLIF(LTRIM(RTRIM(@puesto_contacto)), ''),
                telefono            = NULLIF(LTRIM(RTRIM(@telefono)), ''),
                celular             = NULLIF(LTRIM(RTRIM(@celular)), ''),
                correo_electronico  = NULLIF(LOWER(LTRIM(RTRIM(@correo_electronico))), ''),
                estado              = @estado
            WHERE id_contacto = @id_contacto;

        COMMIT TRANSACTION;

        PRINT 'Contacto actualizado correctamente. ID: ' + CAST(@id_contacto AS VARCHAR(10));

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @err_msg  NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @err_sev  INT            = ERROR_SEVERITY();
        DECLARE @err_sta  INT            = ERROR_STATE();
        RAISERROR(@err_msg, @err_sev, @err_sta);
    END CATCH
END;
GO


-- ---------------------------------------------------------
-- SP 2.3: CONSULTAR CONTACTOS POR CLIENTE
-- Valida que el cliente exista antes de consultar
-- ---------------------------------------------------------
CREATE PROCEDURE dbo.sp_consultar_contactos_por_cliente
    @id_cliente   INT,
    @estado       BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @msg VARCHAR(500);

    -- Validar que el cliente existe
    IF NOT EXISTS (
        SELECT 1 FROM dbo.cliente WHERE id_cliente = @id_cliente
    )
    BEGIN
        SET @msg = 'ERROR: No existe un cliente con id_cliente: ' + CAST(@id_cliente AS VARCHAR(10));
        RAISERROR(@msg, 16, 1);
        RETURN;
    END

    -- Retornar contactos
    SELECT
        ct.id_contacto,
        ct.id_cliente,
        c.codigo_cliente,
        c.nombre_comercial          AS cliente,
        ct.nombre_contacto,
        ct.puesto_contacto,
        ct.telefono,
        ct.celular,
        ct.correo_electronico,
        CASE WHEN ct.estado = 1 THEN 'Activo' ELSE 'Inactivo' END AS estado,
        ct.fecha_creacion
    FROM dbo.contacto ct
    INNER JOIN dbo.cliente c ON c.id_cliente = ct.id_cliente
    WHERE ct.id_cliente = @id_cliente
      AND (@estado IS NULL OR ct.estado = @estado)
    ORDER BY ct.nombre_contacto;
END;
GO


-- =========================================================
-- EJEMPLOS DE USO
-- =========================================================

/*
-- Insertar un cliente
DECLARE @nuevo_id INT;
EXEC dbo.sp_insertar_cliente
    @id_tipo_cliente    = 1,
    @codigo_cliente     = 'CLI-0001',
    @nombre_comercial   = 'Tecnologias del Futuro S.A.',
    @direccion_empresa  = '4a Avenida 10-25 Zona 10, Guatemala',
    @telefono           = '22345678',
    @celular            = '55551234',
    @correo_electronico = 'info@tecfuturo.com',
    @estado             = 1,
    @id_cliente_nuevo   = @nuevo_id OUTPUT;

-- Actualizar un cliente
EXEC dbo.sp_actualizar_cliente
    @id_cliente         = 1,
    @id_tipo_cliente    = 2,
    @nombre_comercial   = 'Tecnologias del Futuro S.A. (Actualizado)',
    @direccion_empresa  = '5a Avenida 12-00 Zona 9, Guatemala',
    @telefono           = '22345678',
    @celular            = '55559999',
    @correo_electronico = 'contacto@tecfuturo.com',
    @estado             = 1;

-- Consultar todos los clientes activos
EXEC dbo.sp_consultar_clientes @estado = 1;

-- Consultar cliente por nombre parcial
EXEC dbo.sp_consultar_clientes @nombre_comercial = 'Tecnologias';

-- Insertar un contacto
DECLARE @nuevo_contacto INT;
EXEC dbo.sp_insertar_contacto
    @id_cliente         = 1,
    @nombre_contacto    = 'Maria Lopez',
    @puesto_contacto    = 'Gerente de Compras',
    @telefono           = '22345679',
    @celular            = '44445555',
    @correo_electronico = 'mlopez@tecfuturo.com',
    @estado             = 1,
    @id_contacto_nuevo  = @nuevo_contacto OUTPUT;

-- Actualizar un contacto
EXEC dbo.sp_actualizar_contacto
    @id_contacto        = 1,
    @id_cliente         = 1,
    @nombre_contacto    = 'Maria Elena Lopez',
    @puesto_contacto    = 'Directora de Compras',
    @telefono           = '22345679',
    @celular            = '44445555',
    @correo_electronico = 'melopez@tecfuturo.com',
    @estado             = 1;

-- Consultar contactos activos de un cliente
EXEC dbo.sp_consultar_contactos_por_cliente @id_cliente = 1, @estado = 1;

-- Consultar todos los contactos de un cliente
EXEC dbo.sp_consultar_contactos_por_cliente @id_cliente = 1;
*/

-- =========================================================
-- FIN DEL SCRIPT
-- =========================================================
