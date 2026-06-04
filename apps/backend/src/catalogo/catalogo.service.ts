import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class CatalogoService {
  constructor(private dataSource: DataSource) {}

  async getTiposCliente() {
    const sql = 'SELECT id_tipo_cliente as id, nombre_tipo as nombre, descripcion FROM dbo.tipo_cliente WHERE estado = 1 ORDER BY nombre_tipo';
    return await this.dataSource.query(sql);
  }

  async getTiposOportunidad() {
    const sql = 'SELECT id_tipo_oportunidad as id, nombre_tipo as nombre, descripcion FROM dbo.tipo_oportunidad WHERE estado = 1 ORDER BY nombre_tipo';
    return await this.dataSource.query(sql);
  }

  async getGestores() {
    const sql = `
      SELECT id_usuario_comercial as id, CONCAT(nombres, ' ', apellidos) as nombre, correo
      FROM dbo.usuario_comercial
      WHERE id_rol_usuario = 1 AND estado = 1
      ORDER BY nombres, apellidos
    `;
    return await this.dataSource.query(sql);
  }

  async getAsistentes() {
    const sql = `
      SELECT id_usuario_comercial as id, CONCAT(nombres, ' ', apellidos) as nombre, correo
      FROM dbo.usuario_comercial
      WHERE id_rol_usuario = 2 AND estado = 1
      ORDER BY nombres, apellidos
    `;
    return await this.dataSource.query(sql);
  }

  async getGerentes() {
    const sql = `
      SELECT id_usuario_comercial as id, CONCAT(nombres, ' ', apellidos) as nombre, correo
      FROM dbo.usuario_comercial
      WHERE id_rol_usuario = 3 AND estado = 1
      ORDER BY nombres, apellidos
    `;
    return await this.dataSource.query(sql);
  }
}
