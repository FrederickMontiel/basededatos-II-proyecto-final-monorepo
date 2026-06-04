-- =========================================================
-- CONFIGURAR MIRRORING - PRINCIPAL (mssql - 5001)
-- =========================================================

-- 1. Crear endpoint para mirroring
CREATE ENDPOINT Mirroring
  STATE = STARTED
  AS TCP
    (LISTENER_PORT = 5022, LISTENER_IP = ALL)
  FOR DATABASE_MIRRORING
    (AUTHENTICATION = WINDOWS NTLM,
     ENCRYPTION = SUPPORTED ALGORITHM AES,
     ROLE = PARTNER);
GO

-- 2. Establecer BD en modo FULL (requerido para mirroring)
ALTER DATABASE InnovacionCRM SET RECOVERY FULL;
GO

-- 3. Hacer backup de la BD
BACKUP DATABASE InnovacionCRM
  TO DISK = N'/var/opt/mssql/backup/innovacion.bak'
  WITH INIT, COMPRESSION;
GO

-- 4. Hacer backup de transaction log
BACKUP LOG InnovacionCRM
  TO DISK = N'/var/opt/mssql/backup/innovacion.trn'
  WITH INIT;
GO

-- 5. Establecer mirror partner
ALTER DATABASE InnovacionCRM
  SET PARTNER = N'TCP://mssql-mirror:5022';
GO

-- 6. Establecer witness (para failover automático)
ALTER DATABASE InnovacionCRM
  SET WITNESS = N'TCP://mssql-witness:5022';
GO

-- =========================================================
-- VERIFICAR ESTADO DEL MIRRORING
-- =========================================================

SELECT
  db_name(database_id) AS [Database],
  mirroring_state_desc AS [Mirroring State],
  mirroring_role_desc AS [Role],
  mirroring_safety_level_desc AS [Safety Level],
  mirroring_witness_state_desc AS [Witness State]
FROM sys.database_mirroring
WHERE database_id > 4;
GO

SELECT * FROM sys.database_mirroring_endpoints;
GO
