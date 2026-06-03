import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UsuarioComercial } from '../entities/usuario-comercial.entity';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class AuthService {
  constructor(
    private jwtService: JwtService,
    @InjectRepository(UsuarioComercial)
    private usuarioRepo: Repository<UsuarioComercial>,
  ) {}

  async login(correo: string, password: string) {
    const usuario = await this.usuarioRepo.findOne({
      where: { correo, estado: true },
    });

    if (!usuario) {
      throw new Error('Usuario o contraseña inválidos');
    }

    const passwordMatch = await bcrypt.compare(password, usuario.password_hash);

    if (!passwordMatch) {
      throw new Error('Usuario o contraseña inválidos');
    }

    usuario.ultimo_acceso = new Date();
    await this.usuarioRepo.save(usuario);

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
