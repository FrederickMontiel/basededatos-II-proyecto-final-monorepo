-- =========================================================
-- CONFIGURAR MIRRORING - MIRROR (mssql-mirror - 5005)
-- =========================================================

-- 1. Crear endpoint
CREATE ENDPOINT Mirroring
  STATE = STARTED
  AS TCP
    (LISTENER_PORT = 5022, LISTENER_IP = ALL)
  FOR DATABASE_MIRRORING
    (ENCRYPTION = DISABLED,
     ROLE = PARTNER);
GO

-- 2. Restaurar BD desde backup (NORECOVERY)
RESTORE DATABASE InnovacionCRM
  FROM DISK = N'/var/opt/mssql/backup/innovacion.bak'
  WITH NORECOVERY;
GO

-- 3. Restaurar transaction log (NORECOVERY)
RESTORE LOG InnovacionCRM
  FROM DISK = N'/var/opt/mssql/backup/innovacion.trn'
  WITH NORECOVERY;
GO

-- 4. Establecer mirror partner
ALTER DATABASE InnovacionCRM
  SET PARTNER = N'TCP://mssql:5022';
GO

-- =========================================================
-- VERIFICAR ESTADO
-- =========================================================

SELECT
  db_name(database_id) AS [Database],
  mirroring_state_desc AS [Mirroring State],
  mirroring_role_desc AS [Role],
  mirroring_safety_level_desc AS [Safety Level]
FROM sys.database_mirroring
WHERE database_id > 4;
GO
