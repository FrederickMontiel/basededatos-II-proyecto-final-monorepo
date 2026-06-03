USE InnovacionCRM;
GO

CREATE OR ALTER TRIGGER dbo.trg_ValidarCierreOportunidad
ON dbo.oportunidad
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.estado_oportunidad eo
            ON i.id_estado_oportunidad = eo.id_estado_oportunidad
        WHERE eo.nombre_estado IN ('Ganado', 'Perdida')
          AND i.porcentaje_avance <> 100
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51001, 'La oportunidad solo puede cerrarse como ganada o perdida si el porcentaje de avance es 100%.', 1;
    END
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_ExigirComentarioCierre
ON dbo.oportunidad
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.estado_oportunidad eo
            ON i.id_estado_oportunidad = eo.id_estado_oportunidad
        WHERE eo.nombre_estado IN ('Ganado', 'Perdida')
          AND (i.comentario_cierre IS NULL OR LTRIM(RTRIM(i.comentario_cierre)) = '')
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 51002, 'Debe ingresar un comentario cuando la oportunidad se marque como ganada o perdida.', 1;
    END
END;
GO