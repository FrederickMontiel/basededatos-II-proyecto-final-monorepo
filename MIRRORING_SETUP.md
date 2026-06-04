# Configuración de Mirroring con Failover Automático

## Arquitectura

```
Principal (5001) <--mirror--> Mirror (5005)
      |                            |
      +-------- Witness (5004) ----+
```

## Pasos de Configuración

### 1. Levantar contenedores

```bash
docker-compose up -d mssql mssql-mirror mssql-witness
```

Esperar a que los 3 contenedores estén healthy (~30s):

```bash
docker-compose ps
```

### 2. Copiar backup al mirror

```bash
# Crear directorio backup en mirror
docker exec innovacion-crm-mssql mkdir -p /var/opt/mssql/backup

# Copiar archivos backup
docker cp /path/to/innovacion.bak innovacion-crm-mssql-mirror:/var/opt/mssql/backup/
docker cp /path/to/innovacion.trn innovacion-crm-mssql-mirror:/var/opt/mssql/backup/
```

O generar backup dentro del principal:

```bash
docker exec innovacion-crm-mssql sqlcmd -S localhost -U sa -P Pass1234 -Q \
  "BACKUP DATABASE InnovacionCRM TO DISK='/var/opt/mssql/backup/innovacion.bak' WITH INIT, COMPRESSION"
```

### 3. Ejecutar setup-mirroring.sql

En el **Principal** (5001):

```bash
docker exec innovacion-crm-mssql sqlcmd -S localhost -U sa -P Pass1234 -i /scripts/setup-mirroring.sql
```

En el **Mirror** (5005):

```bash
docker exec innovacion-crm-mssql-mirror sqlcmd -S localhost -U sa -P Pass1234 \
  -i /setup-mirror.sql
```

En el **Witness** (5004):

```bash
docker exec innovacion-crm-mssql-witness sqlcmd -S localhost -U sa -P Pass1234 \
  -i /setup-witness.sql
```

### 4. Verificar estado

En el Principal:

```bash
docker exec innovacion-crm-mssql sqlcmd -S localhost -U sa -P Pass1234 -Q \
  "SELECT db_name(database_id) AS [Database], mirroring_state_desc AS [State], mirroring_role_desc AS [Role], mirroring_safety_level_desc AS [Safety], mirroring_witness_state_desc AS [Witness] FROM sys.database_mirroring WHERE database_id > 4"
```

Expected output:
```
Database              State              Role        Safety                    Witness
InnovacionCRM         SYNCHRONIZED       PRINCIPAL   FULL                      CONNECTED
```

## Failover Automático

Con witness configurado, el failover es **automático**:

- Si Principal cae → Mirror asume rol de Principal automáticamente
- Failover tarda ~5-10 segundos
- Witness arbitra quién es principal

## Cambiar conexión backend

En caso de failover manual o para usar Mirror:

```bash
# En .env o docker-compose.yml
DATABASE_HOST=mssql-mirror  # cambiar a mirror si es necesario
DATABASE_PORT=1433
```

## Monitoreo

Ver estado en tiempo real:

```bash
docker exec innovacion-crm-mssql sqlcmd -S localhost -U sa -P Pass1234 <<EOF
SET NOCOUNT ON
DECLARE @interval INT = 5
WHILE 1 = 1
BEGIN
  CLEAR
  SELECT 
    GETDATE() AS [Timestamp],
    db_name(database_id) AS [Database],
    mirroring_state_desc AS [State],
    mirroring_role_desc AS [Role],
    mirroring_safety_level_desc AS [Safety],
    mirroring_witness_state_desc AS [Witness]
  FROM sys.database_mirroring 
  WHERE database_id > 4
  
  WAITFOR DELAY '00:00:' + RIGHT('00' + CAST(@interval AS VARCHAR(2)), 2)
END
EOF
```

## Troubleshooting

### Mirror no sincroniza

```sql
-- En Mirror, ver error:
SELECT error_number, error_severity, error_state, error_message 
FROM sys.dm_exec_requests 
WHERE session_id > 50
```

### Endpoint no creado

Verificar que sea accesible:

```bash
docker exec innovacion-crm-mssql sqlcmd -S localhost -U sa -P Pass1234 \
  -Q "SELECT * FROM sys.database_mirroring_endpoints"
```

### Witness desconectado

Verificar conectividad entre contenedores:

```bash
docker exec innovacion-crm-mssql ping mssql-witness
docker exec innovacion-crm-mssql ping mssql-mirror
```
