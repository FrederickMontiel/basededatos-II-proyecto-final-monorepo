import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ClienteService } from './cliente/cliente.service';
import { ClienteController } from './cliente/cliente.controller';
import { ContactoService } from './contacto/contacto.service';
import { ContactoController } from './contacto/contacto.controller';
import { OportunidadService } from './oportunidad/oportunidad.service';
import { OportunidadController } from './oportunidad/oportunidad.controller';
import { ActividadService } from './actividad/actividad.service';
import { ActividadController } from './actividad/actividad.controller';
import { ReportesService } from './reportes/reportes.service';
import { ReportesController } from './reportes/reportes.controller';
import { AuthService } from './auth/auth.service';
import { AuthController } from './auth/auth.controller';
import { JwtStrategy } from './auth/jwt.strategy';
import * as dotenv from 'dotenv';
import * as path from 'path';

const envPath = path.join(process.cwd(), '.env');
dotenv.config({ path: envPath });

console.log('📁 Loading .env from:', envPath);
console.log('🔌 DB Credentials:', {
  host: process.env.DATABASE_HOST,
  port: process.env.DATABASE_PORT,
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
});

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: `${process.cwd()}/.env`,
    }),
    TypeOrmModule.forRoot({
      type: 'mssql',
      host: process.env.DATABASE_HOST,
      port: parseInt(process.env.DATABASE_PORT as string),
      username: process.env.DATABASE_USER,
      password: process.env.DATABASE_PASSWORD,
      database: process.env.DATABASE_NAME,
      entities: [__dirname + '/entities/**/*.entity{.ts,.js}'],
      migrations: [__dirname + '/migrations/**/*{.ts,.js}'],
      migrationsRun: false,
      synchronize: false,
      options: {
        trustServerCertificate: true,
        encrypt: false,
      },
    }),
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'your-secret-key-change-in-production',
      signOptions: { expiresIn: '1h' },
    }),
  ],
  controllers: [
    AppController,
    AuthController,
    ClienteController,
    ContactoController,
    OportunidadController,
    ActividadController,
    ReportesController,
  ],
  providers: [
    AppService,
    AuthService,
    JwtStrategy,
    ClienteService,
    ContactoService,
    OportunidadService,
    ActividadService,
    ReportesService,
  ],
})
export class AppModule { }
