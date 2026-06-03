import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ClienteService {
  constructor(private dataSource: DataSource) {}

  async insertar(clienteData: any) {
    const sql = `
      DECLARE @id_tipo_cliente INT = ${clienteData.id_tipo_cliente};
      DECLARE @codigo_cliente VARCHAR(50) = '${this.escape(clienteData.codigo || clienteData.codigo_cliente)}';
      DECLARE @nombre_comercial VARCHAR(120) = '${this.escape(clienteData.nombre || clienteData.nombre_comercial)}';
      DECLARE @direccion_empresa VARCHAR(255) = ${(clienteData.direccion || clienteData.direccion_empresa) ? `'${this.escape(clienteData.direccion || clienteData.direccion_empresa)}'` : 'NULL'};
      DECLARE @telefono VARCHAR(25) = ${clienteData.telefono ? `'${this.escape(clienteData.telefono)}'` : 'NULL'};
      DECLARE @celular VARCHAR(25) = ${clienteData.celular ? `'${this.escape(clienteData.celular)}'` : 'NULL'};
      DECLARE @correo_electronico VARCHAR(100) = ${(clienteData.correo || clienteData.correo_electronico) ? `'${this.escape(clienteData.correo || clienteData.correo_electronico)}'` : 'NULL'};
      DECLARE @estado BIT = ${clienteData.estado !== undefined ? clienteData.estado : 1};
      DECLARE @id_cliente_nuevo INT;
      EXEC sp_insertar_cliente @id_tipo_cliente, @codigo_cliente, @nombre_comercial, @direccion_empresa, @telefono, @celular, @correo_electronico, @estado, @id_cliente_nuevo OUTPUT;
      SELECT @id_cliente_nuevo AS id_cliente_nuevo;
    `;
    const result = await this.dataSource.query(sql);
    return result;
  }

  async actualizar(id: number, clienteData: any) {
    const sql = `
      DECLARE @id_cliente INT = ${id};
      DECLARE @id_tipo_cliente INT = ${clienteData.id_tipo_cliente};
      DECLARE @nombre_comercial VARCHAR(120) = '${this.escape(clienteData.nombre || clienteData.nombre_comercial)}';
      DECLARE @direccion_empresa VARCHAR(255) = ${(clienteData.direccion || clienteData.direccion_empresa) ? `'${this.escape(clienteData.direccion || clienteData.direccion_empresa)}'` : 'NULL'};
      DECLARE @telefono VARCHAR(25) = ${clienteData.telefono ? `'${this.escape(clienteData.telefono)}'` : 'NULL'};
      DECLARE @celular VARCHAR(25) = ${clienteData.celular ? `'${this.escape(clienteData.celular)}'` : 'NULL'};
      DECLARE @correo_electronico VARCHAR(100) = ${(clienteData.correo || clienteData.correo_electronico) ? `'${this.escape(clienteData.correo || clienteData.correo_electronico)}'` : 'NULL'};
      DECLARE @estado BIT = ${clienteData.estado !== undefined ? clienteData.estado : 1};
      EXEC sp_actualizar_cliente @id_cliente, @id_tipo_cliente, @nombre_comercial, @direccion_empresa, @telefono, @celular, @correo_electronico, @estado;
    `;
    await this.dataSource.query(sql);
    return { success: true };
  }

  async consultar(filtros?: any) {
    const sql = `
      DECLARE @id_cliente INT = ${filtros?.id_cliente || 'NULL'};
      DECLARE @codigo_cliente VARCHAR(50) = ${filtros?.codigo_cliente ? `'${this.escape(filtros.codigo_cliente)}'` : 'NULL'};
      DECLARE @nombre_comercial VARCHAR(120) = ${filtros?.nombre_comercial ? `'${this.escape(filtros.nombre_comercial)}'` : 'NULL'};
      DECLARE @id_tipo_cliente INT = ${filtros?.id_tipo_cliente || 'NULL'};
      DECLARE @estado BIT = ${filtros?.estado !== undefined ? filtros.estado : 'NULL'};
      EXEC sp_consultar_clientes @id_cliente, @codigo_cliente, @nombre_comercial, @id_tipo_cliente, @estado;
    `;
    const result = await this.dataSource.query(sql);
    return result;
  }

  private escape(str: string): string {
    return str.replace(/'/g, "''");
  }
}
