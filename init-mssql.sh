#!/bin/bash

# Script de inicialización para MSSQL con mirroring automático

MSSQL_CONTAINER_NAME="${1:-innovacion-crm-mssql}"
ROLE="${2:-principal}"  # principal, mirror, witness

echo "=========================================="
echo "Inicializando MSSQL: $MSSQL_CONTAINER_NAME ($ROLE)"
echo "=========================================="

# Función para ejecutar SQL con reintentos
execute_sql() {
  local query="$1"
  local max_retries=3
  local retry=0

  while [ $retry -lt $max_retries ]; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P Pass1234 -C -Q "$query" 2>/dev/null; then
      return 0
    fi
    retry=$((retry + 1))
    [ $retry -lt $max_retries ] && sleep 1
  done
  return 1
}

execute_sql_file() {
  local file="$1"
  local max_retries=3
  local retry=0

  while [ $retry -lt $max_retries ]; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P Pass1234 -C -i "$file" 2>/dev/null; then
      return 0
    fi
    retry=$((retry + 1))
    [ $retry -lt $max_retries ] && sleep 1
  done
  return 1
}

# Esperar a que MSSQL esté listo (máx 60s)
echo "Esperando MSSQL..."
for i in {1..30}; do
  if execute_sql "SELECT 1" &>/dev/null; then
    echo "✓ MSSQL listo"
    break
  fi
  echo "  Intento $i/30..."
  sleep 2
done

# Ejecutar según rol
case "$ROLE" in
  principal)
    echo "→ Configurando como Principal..."

    # 1. Ejecutar init.sql (crea BD + schema + datos)
    if [ -f "/scripts/init.sql" ]; then
      echo "  Ejecutando init.sql..."
      execute_sql_file "/scripts/init.sql" || echo "  ⚠ init.sql parcial"
    else
      echo "  ⚠ init.sql no encontrado, creando BD vacía..."
      execute_sql "IF DB_ID('InnovacionCRM') IS NULL CREATE DATABASE InnovacionCRM"
    fi

    # 2. Configurar recovery FULL antes de backup
    echo "  Configurando recovery mode..."
    execute_sql "ALTER DATABASE InnovacionCRM SET RECOVERY FULL" || true
    sleep 3

    # 3. Crear backups para mirroring (en /var/opt/mssql/backup dentro del volumen compartido)
    echo "  Creando backups..."
    execute_sql "BACKUP DATABASE InnovacionCRM TO DISK='/var/opt/mssql/backup/innovacion.bak' WITH INIT, COMPRESSION" && \
      echo "  ✓ DB backup creado" || echo "  ⚠ Error en DB backup"
    sleep 1
    execute_sql "BACKUP LOG InnovacionCRM TO DISK='/var/opt/mssql/backup/innovacion.trn'" && \
      echo "  ✓ Log backup creado" || echo "  ⚠ Error en Log backup"
    sleep 2

    # 5. Configurar mirroring
    if [ -f "/scripts/setup-mirroring-principal.sql" ]; then
      echo "  Configurando mirroring (principal)..."
      execute_sql_file "/scripts/setup-mirroring-principal.sql" && \
        echo "  ✓ Mirroring principal configurado" || \
        echo "  ⚠ Mirroring parcial (posible timeout esperando mirror/witness)"
    fi
    ;;

  mirror)
    echo "→ Configurando como Mirror..."

    # Esperar a que backups estén disponibles en volumen del principal (máx 120s)
    echo "  Esperando backups del principal..."
    BACKUP_READY=0
    for i in {1..120}; do
      if [ -f "/mnt/principal_backup/backup/innovacion.bak" ] && [ -f "/mnt/principal_backup/backup/innovacion.trn" ]; then
        echo "  ✓ Backups disponibles (intento $i)"
        BACKUP_READY=1
        break
      fi
      if [ $((i % 10)) -eq 0 ]; then
        echo "  Esperando... ($i/120s)"
      fi
      sleep 1
    done

    if [ $BACKUP_READY -eq 1 ]; then
      # Copiar backups a nuestro volumen (para que RESTORE funcione)
      echo "  Copiando backups..."
      mkdir -p /var/opt/mssql/backup
      cp /mnt/principal_backup/backup/innovacion.bak /var/opt/mssql/backup/ 2>/dev/null || true
      cp /mnt/principal_backup/backup/innovacion.trn /var/opt/mssql/backup/ 2>/dev/null || true

      if [ -f "/scripts/setup-mirroring-mirror.sql" ]; then
        echo "  Restaurando BD y configurando mirror..."
        execute_sql_file "/scripts/setup-mirroring-mirror.sql" && \
          echo "  ✓ Mirror configurado" || \
          echo "  ⚠ Mirror parcial (posible timeout esperando principal)"
      fi
    else
      echo "  ✗ Timeout esperando backups (principal no respondió)"
    fi
    ;;

  witness)
    echo "→ Configurando como Witness..."

    # Esperar MSSQL en witness (ya esperado arriba)
    if [ -f "/scripts/setup-mirroring-witness.sql" ]; then
      echo "  Creando endpoint witness..."
      execute_sql_file "/scripts/setup-mirroring-witness.sql" && \
        echo "  ✓ Witness endpoint creado" || \
        echo "  ⚠ Witness parcial"
    fi
    ;;
esac

echo "✓ Inicialización completada"
sleep 2
