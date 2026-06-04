-- =========================================================
-- CONFIGURAR MIRRORING - WITNESS (mssql-witness - 5004)
-- =========================================================

-- 1. Crear endpoint WITNESS
CREATE ENDPOINT Mirroring
  STATE = STARTED
  AS TCP
    (LISTENER_PORT = 5022, LISTENER_IP = ALL)
  FOR DATABASE_MIRRORING
    (AUTHENTICATION = WINDOWS NTLM,
     ENCRYPTION = SUPPORTED ALGORITHM AES,
     ROLE = WITNESS);
GO

-- =========================================================
-- VERIFICAR ENDPOINT
-- =========================================================

SELECT * FROM sys.database_mirroring_endpoints;
GO
