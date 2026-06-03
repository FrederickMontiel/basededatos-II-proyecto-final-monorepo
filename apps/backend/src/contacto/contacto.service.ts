import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ContactoService {
  constructor(private dataSource: DataSource) {}

  async listar() {
    return await this.dataSource.query('SELECT * FROM contacto');
  }

  async obtenerPorId(id: number) {
    const result = await this.dataSource.query(`SELECT * FROM contacto WHERE id_contacto = ${id}`);
    return result[0];
  }

  async insertar(contactoData: any) {
    const sql = `
      DECLARE @id_cliente INT = ${parseInt(contactoData.id_cliente)};
      DECLARE @nombre_contacto VARCHAR(100) = '${this.escape(contactoData.nombre_contacto)}';
      DECLARE @puesto_contacto VARCHAR(100) = ${contactoData.puesto_contacto ? `'${this.escape(contactoData.puesto_contacto)}'` : 'NULL'};
      DECLARE @telefono VARCHAR(25) = ${contactoData.telefono ? `'${this.escape(contactoData.telefono)}'` : 'NULL'};
      DECLARE @celular VARCHAR(25) = ${contactoData.celular ? `'${this.escape(contactoData.celular)}'` : 'NULL'};
      DECLARE @correo_electronico VARCHAR(100) = ${contactoData.correo_electronico ? `'${this.escape(contactoData.correo_electronico)}'` : 'NULL'};
      DECLARE @estado BIT = ${contactoData.estado !== undefined ? parseInt(contactoData.estado) : 1};
      DECLARE @id_contacto_nuevo INT;
      EXEC sp_insertar_contacto @id_cliente, @nombre_contacto, @puesto_contacto, @telefono, @celular, @correo_electronico, @estado, @id_contacto_nuevo OUTPUT;
      SELECT @id_contacto_nuevo AS id_contacto_nuevo;
    `;
    return await this.dataSource.query(sql);
  }

  async actualizar(id: number, contactoData: any) {
    const sql = `
      DECLARE @id_contacto INT = ${id};
      DECLARE @id_cliente INT = ${parseInt(contactoData.id_cliente)};
      DECLARE @nombre_contacto VARCHAR(100) = '${this.escape(contactoData.nombre_contacto)}';
      DECLARE @puesto_contacto VARCHAR(100) = ${contactoData.puesto_contacto ? `'${this.escape(contactoData.puesto_contacto)}'` : 'NULL'};
      DECLARE @telefono VARCHAR(25) = ${contactoData.telefono ? `'${this.escape(contactoData.telefono)}'` : 'NULL'};
      DECLARE @celular VARCHAR(25) = ${contactoData.celular ? `'${this.escape(contactoData.celular)}'` : 'NULL'};
      DECLARE @correo_electronico VARCHAR(100) = ${contactoData.correo_electronico ? `'${this.escape(contactoData.correo_electronico)}'` : 'NULL'};
      DECLARE @estado BIT = ${contactoData.estado !== undefined ? parseInt(contactoData.estado) : 1};
      EXEC sp_actualizar_contacto @id_contacto, @id_cliente, @nombre_contacto, @puesto_contacto, @telefono, @celular, @correo_electronico, @estado;
    `;
    await this.dataSource.query(sql);
    return { success: true };
  }

  async consultarPorCliente(idCliente: number, estado?: number) {
    const sql = `
      DECLARE @id_cliente INT = ${idCliente};
      DECLARE @estado BIT = ${estado !== undefined ? estado : 'NULL'};
      EXEC sp_consultar_contactos_por_cliente @id_cliente, @estado;
    `;
    return await this.dataSource.query(sql);
  }

  private escape(str: string): string {
    return str.replace(/'/g, "''");
  }
}
