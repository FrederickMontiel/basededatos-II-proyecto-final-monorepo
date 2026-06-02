# Guía de Desarrollo

## Setup Inicial

### 1. Clonar y configurar

```bash
git clone <url>
cd proyecto-final
git config user.email "tu@email.com"
git config user.name "Tu Nombre"
```

### 2. Levantar Docker

```bash
npm run dev
npm run dev:logs  # Ver que todo esté iniciando bien
```

### 3. Esperar a que servicios estén listos

```
- MSSQL: Status = healthy (ver en docker logs)
- Backend: escuchando en puerto 3000
- Frontend: escuchando en puerto 4200
```

## Desarrollo Backend (NestJS)

### Crear nuevo módulo

```bash
cd apps/backend
npx @nestjs/cli@latest g module modules/clientes
npx @nestjs/cli@latest g service modules/clientes/servicios/clientes
npx @nestjs/cli@latest g controller modules/clientes/controladores/clientes
```

### Estructura de módulo

```
modules/clientes/
├── controladores/
│   └── clientes.controller.ts
├── servicios/
│   └── clientes.service.ts
├── entidades/
│   └── cliente.entity.ts
├── dto/
│   ├── crear-cliente.dto.ts
│   └── actualizar-cliente.dto.ts
├── interfaces/
│   └── cliente.interface.ts
└── clientes.module.ts
```

### Crear entidad TypeORM

```typescript
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('cliente')
export class ClienteEntity {
  @PrimaryGeneratedColumn('increment', { name: 'id_cliente' })
  id: number;

  @Column({ name: 'nombre_comercial', length: 150 })
  nombre: string;
}
```

### Inyectar repositorio en servicio

```typescript
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClienteEntity } from '../entidades/cliente.entity';

@Injectable()
export class ClientesService {
  constructor(
    @InjectRepository(ClienteEntity)
    private clienteRepository: Repository<ClienteEntity>,
  ) {}

  async obtenerTodos() {
    return this.clienteRepository.find();
  }
}
```

## Desarrollo Frontend (Angular)

### Crear componente

```bash
cd apps/frontend
ng generate component components/clientes/lista-clientes
ng generate component components/clientes/formulario-cliente
```

### Crear servicio

```bash
ng generate service services/cliente
```

### Estructura de componentes

```
src/app/
├── components/
│   ├── clientes/
│   │   ├── lista-clientes/
│   │   └── formulario-cliente/
│   ├── oportunidades/
│   ├── actividades/
│   └── compartido/
├── services/
│   ├── cliente.service.ts
│   ├── oportunidad.service.ts
│   └── actividad.service.ts
├── models/
│   ├── cliente.model.ts
│   ├── oportunidad.model.ts
│   └── actividad.model.ts
└── layouts/
    └── main-layout/
```

### Llamar API desde servicio

```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ClienteService {
  private apiUrl = 'http://localhost:3000/api/clientes';

  constructor(private http: HttpClient) {}

  obtenerClientes(): Observable<any> {
    return this.http.get(this.apiUrl);
  }

  crearCliente(cliente: any): Observable<any> {
    return this.http.post(this.apiUrl, cliente);
  }
}
```

### Usar servicio en componente

```typescript
import { Component, OnInit } from '@angular/core';
import { ClienteService } from '../../services/cliente.service';

@Component({
  selector: 'app-lista-clientes',
  templateUrl: './lista-clientes.component.html',
  styleUrls: ['./lista-clientes.component.css'],
})
export class ListaClientesComponent implements OnInit {
  clientes: any[] = [];
  loading = true;

  constructor(private clienteService: ClienteService) {}

  ngOnInit() {
    this.clienteService.obtenerClientes().subscribe({
      next: (data) => {
        this.clientes = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error al cargar clientes', err);
        this.loading = false;
      },
    });
  }
}
```

## Base de Datos

### Visualizar datos

```bash
# Desde Windows, usar SQL Server Management Studio
# Conectar a: localhost,1433
# Usuario: sa
# Contraseña: YourPassword123
```

### Ejecutar scripts SQL

```bash
# Dentro del contenedor
docker exec innovacion-crm-mssql \
  /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P YourPassword123 \
  -Q "SELECT * FROM cliente"
```

## Testing

### Backend

```bash
cd apps/backend
npm test                    # Ejecutar tests
npm run test:watch         # Watch mode
npm run test:cov           # Coverage
```

### Frontend

```bash
cd apps/frontend
npm test                    # Ejecutar tests
```

## Git Workflow

```bash
# Crear rama feature
git checkout -b feature/gestionar-clientes

# Hacer cambios
git add .
git commit -m "feat: agregar CRUD de clientes"

# Subir rama
git push origin feature/gestionar-clientes

# Crear Pull Request en GitHub/GitLab
```

## Commits (Conventional Commits)

```
feat:     Nueva característica
fix:      Corrección de bug
refactor: Cambios sin afectar funcionalidad
test:     Agregar o actualizar tests
docs:     Cambios en documentación
style:    Cambios de formato
chore:    Cambios en dependencias, builds, etc.
```

Ejemplo:
```bash
git commit -m "feat: agregar endpoint POST para crear cliente"
git commit -m "fix: validar correo duplicado en clientes"
```

## Troubleshooting

### Backend no inicia

```bash
docker logs innovacion-crm-backend
# Verificar:
# - Dependencias instaladas (npm install)
# - Puerto 3000 disponible
# - Base de datos conectada
```

### Frontend no compila

```bash
cd apps/frontend
rm -rf node_modules package-lock.json
npm install
npm start
```

### Hot-reload no funciona

Los cambios deben reflejarse automáticamente. Si no:
- Verificar volúmenes en docker-compose.yml
- Reiniciar contenedor: `docker-compose restart frontend`

### Errores de CORS

Configurar en backend (src/main.ts):
```typescript
app.enableCors({
  origin: 'http://localhost:4200',
  credentials: true,
});
```

## Recursos Útiles

- [NestJS Docs](https://docs.nestjs.com)
- [Angular Docs](https://angular.io/docs)
- [TypeORM Docs](https://typeorm.io)
- [MSSQL Docs](https://docs.microsoft.com/sql)

## Contacto

Preguntas o problemas: Frederick Montiel (femontielt@gmail.com)
