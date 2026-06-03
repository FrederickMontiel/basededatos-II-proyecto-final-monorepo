import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class AuthService {
  constructor(
    private jwtService: JwtService,
    private dataSource: DataSource,
  ) {}

  async login(correo: string, password: string) {
    const result = await this.dataSource.query(
      'SELECT id_usuario_comercial, correo, password_hash, nombres, apellidos, id_rol_usuario FROM dbo.usuario_comercial WHERE correo = @correo AND estado = 1',
      [correo],
    );

    if (result.length === 0) {
      throw new Error('Usuario o contraseña inválidos');
    }

    const usuario = result[0];
    const passwordMatch = await bcrypt.compare(password, usuario.password_hash);

    if (!passwordMatch) {
      throw new Error('Usuario o contraseña inválidos');
    }

    await this.dataSource.query(
      'UPDATE dbo.usuario_comercial SET ultimo_acceso = GETDATE() WHERE id_usuario_comercial = @id',
      [usuario.id_usuario_comercial],
    );

    const payload = {
      sub: usuario.id_usuario_comercial,
      correo: usuario.correo,
      nombres: usuario.nombres,
      apellidos: usuario.apellidos,
      id_rol_usuario: usuario.id_rol_usuario,
    };

    return {
      access_token: this.jwtService.sign(payload),
      refresh_token: this.jwtService.sign(payload, { expiresIn: '7d' }),
      usuario: {
        id: usuario.id_usuario_comercial,
        correo: usuario.correo,
        nombres: usuario.nombres,
        apellidos: usuario.apellidos,
      },
    };
  }

  async refresh(payload: any) {
    const newPayload = {
      sub: payload.sub,
      correo: payload.correo,
      nombres: payload.nombres,
      apellidos: payload.apellidos,
      id_rol_usuario: payload.id_rol_usuario,
    };

    return {
      access_token: this.jwtService.sign(newPayload),
      refresh_token: this.jwtService.sign(newPayload, { expiresIn: '7d' }),
    };
  }
}
