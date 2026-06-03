USE InnovacionCRM;
GO

CREATE OR ALTER FUNCTION dbo.fn_CalcularMontoPonderado
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

CREATE OR ALTER FUNCTION dbo.fn_ObtenerPorcentajeEtapa
(
    @id_etapa_oportunidad INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @porcentaje DECIMAL(5,2);

    SELECT @porcentaje = porcentaje_cierre
    FROM dbo.etapa_oportunidad
    WHERE id_etapa_oportunidad = @id_etapa_oportunidad
      AND estado = 1;

    RETURN @porcentaje;
END;
GO

SELECT dbo.fn_CalcularMontoPonderado(60000.00, 30.00) AS monto_ponderado_prueba;
SELECT dbo.fn_ObtenerPorcentajeEtapa(1) AS porcentaje_etapa_prueba;
GO