# Innovacion CRM - Monorepo

Sistema CRM para el seguimiento comercial de Innovacion, S.A.

## Estructura del Proyecto

```
proyecto-final/
├── apps/
│   ├── backend/        # NestJS API
│   ├── frontend/       # Angular Web App
│   └── database/       # MSSQL Scripts
├── docker-compose.yml  # Configuración Docker
└── package.json        # Workspace root
```

## Requisitos

- Docker Desktop instalado
- Git
- Node.js 18+ (opcional, para desarrollo local)

## Instalación y Ejecución

### 1. Clonar el repositorio

```bash
git clone <repositorio>
cd proyecto-final
```

### 2. Levantar los servicios con Docker

```bash
# Iniciar todos los servicios en background
npm run dev

# Ver logs en tiempo real
npm run dev:logs

# Reconstruir imágenes
npm run dev:rebuild

# Detener servicios
npm run dev:down
```

### 3. Acceder a las aplicaciones

- **Frontend (Angular)**: http://localhost:5003
- **Backend (API)**: http://localhost:5002/api
- **Database (MSSQL)**: localhost:5001

### 4. Inicializar base de datos

```bash
# Después de que MSSQL esté listo
npm run db:init
```

## Puertos y Credenciales

| Servicio | Puerto Expuesto | Usuario | Contraseña |
|----------|-----------------|---------|------------|
| MSSQL    | 5001            | sa      | YourPassword123 |
| Backend  | 5002            | -       | -           |
| Frontend | 5003            | -       | -           |

⚠️ **Cambiar credenciales en producción**

## Desarrollo

### Backend (NestJS)

```bash
cd apps/backend

# Instalar dependencias
npm install

# Desarrollo con hot-reload
npm run start:dev

# Build
npm run build

# Tests
npm run test
```

### Frontend (Angular)

```bash
cd apps/frontend

# Instalar dependencias
npm install

# Desarrollo con hot-reload
npm start

# Build
npm run build

# Tests
npm test
```

## Estructura de Carpetas

### Backend

```
apps/backend/
├── src/
│   ├── main.ts                 # Punto de entrada
│   ├── app.module.ts           # Módulo raíz
│   ├── entities/               # Entidades TypeORM
│   ├── auth/                   # Autenticación JWT
│   ├── cliente/                # Gestión de clientes
│   ├── contacto/               # Gestión de contactos
│   ├── actividad/              # Gestión de actividades
│   ├── oportunidad/            # Gestión de oportunidades
│   └── reportes/               # Reportes
├── Dockerfile
└── package.json
```

### Frontend

```
apps/frontend/
├── src/
│   ├── main.ts                 # Bootstrap
│   ├── app/
│   │   ├── components/         # Componentes
│   │   ├── services/           # Servicios HTTP
│   │   ├── models/             # Interfaces
│   │   └── app.component.ts
│   └── assets/
├── Dockerfile
├── angular.json
└── package.json
```

### Database

```
apps/database/
├── final.sql                   # Schema y datos iniciales
└── migrations/                 # Scripts adicionales
```

## Módulos del Sistema

### 0. Autenticación
- Login con usuario y contraseña
- Token JWT para APIs
- Roles de usuario (Administrador, Gestor Comercial, Consultor)

### 1. Clientes
- Crear, actualizar, consultar clientes
- Tipos: Potencial, Final
- Campos: código, nombre, dirección, teléfono, correo

### 2. Contactos
- Gestionar contactos por cliente
- Campos: nombre, puesto, teléfono, correo, empresa

### 3. Oportunidades
- Crear oportunidades de venta
- Etapas: 20%, 30%, 50%, 80%, 95%, 100%
- Cálculo automático de montos ponderados
- Validaciones de cierre

### 4. Actividades
- Registrar actividades (llamadas, reuniones, tareas)
- Tipos: Llamada, Reunión, Tarea, Nota, etc.
- Prioridades: Normal, Alto, Bajo
- Estados personalizados según tipo

### 5. Reportes
- Oportunidades por rango de fechas
- Oportunidades por usuario comercial
- Análisis de conversión (ganadas/perdidas)
- Resumen de actividades

## Variables de Entorno

### Backend (.env)

```
NODE_ENV=development
DATABASE_HOST=mssql
DATABASE_PORT=1433          # Puerto interno de Docker
DATABASE_USER=sa
DATABASE_PASSWORD=YourPassword123
DATABASE_NAME=InnovacionCRM
PORT=3000                   # Puerto interno de Docker
```

### Frontend (environment.ts)

```
API_URL=http://localhost:5002/api  # Puerto expuesto en máquina local
```

## Migraciones de Base de Datos

Las migraciones se ejecutan automáticamente en el startup del backend.

Para crear nuevas migraciones:

```bash
cd apps/backend
npm run typeorm migration:create -- src/migrations/CreateNuevaTabla
```

## Testing

```bash
# Backend
cd apps/backend && npm test

# Frontend
cd apps/frontend && npm test
```

## Troubleshooting

### Puerto ya en uso

Si el puerto está ocupado, cambiar en docker-compose.yml:

```yaml
mssql:
  ports:
    - "5001:1433"  # Puerto expuesto:interno

backend:
  ports:
    - "5002:3000"

frontend:
  ports:
    - "5003:4200"
```

### MSSQL no inicia

```bash
# Verificar logs
docker logs innovacion-crm-mssql

# Reiniciar servicio
docker-compose restart mssql
```

### Frontend no conecta a API

Verificar variable `API_URL` y CORS en Backend.

```bash
# Probar endpoint desde navegador
curl http://localhost:3000/api/health
```

## Producción

Para deployment:

```bash
# Build all
docker-compose -f docker-compose.prod.yml build

# Deploy
docker-compose -f docker-compose.prod.yml up -d
```

Cambiar credenciales en `.env.production`.

## Contribuciones

1. Crear rama feature: `git checkout -b feature/nombre`
2. Commit cambios: `git commit -m "Descripción"`
3. Push: `git push origin feature/nombre`
4. Pull Request

## Licencia

MIT
