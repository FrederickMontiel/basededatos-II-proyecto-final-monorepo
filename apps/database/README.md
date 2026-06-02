# Database - MSSQL

Configuración y scripts SQL para la base de datos InnovacionCRM.

## Archivos

- `init.sql` - Script de inicialización (tablas, catalogos, datos iniciales)
- `final.sql` - Script completo con funciones, procedimientos y triggers

## Inicialización Automática

Docker ejecuta `init.sql` automáticamente al iniciar el contenedor de MSSQL.

## Conexión

```
Host: localhost
Puerto: 1433
Usuario: sa
Contraseña: YourPassword123
Database: InnovacionCRM
```

## Ejecutar SQL manualmente

```bash
# Desde el contenedor MSSQL
docker exec innovacion-crm-mssql \
  /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P YourPassword123 \
  -i /scripts/init.sql
```

## Estructura de la Base de Datos

### Tablas Principales

- **usuario_comercial** - Usuarios del sistema
- **cliente** - Clientes
- **contacto** - Contactos por cliente
- **oportunidad** - Oportunidades de venta
- **actividad** - Actividades/tareas
- **detalle_reunion** - Detalles de reuniones

### Tablas Catalogo

- **rol_usuario** - Roles
- **tipo_cliente** - Tipos de cliente
- **tipo_oportunidad** - Tipos de oportunidad
- **estado_oportunidad** - Estados (Abierto, Ganado, Perdida)
- **etapa_oportunidad** - Etapas con % de cierre
- **tipo_actividad** - Tipos de actividad
- **prioridad_actividad** - Prioridades
- **estado_actividad** - Estados de actividad
- **finalizacion_actividad** - Finalizaciones

## Migraciones

Las migraciones adicionales deben:

1. Crear archivo `.sql` en esta carpeta
2. Nombrar con patrón: `YYYYMMDD_descripcion.sql`
3. Documentar cambios en este README
