import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ClienteService {
  constructor(private dataSource: DataSource) {}

  async insertar(clienteData: any) {
    const result = await this.dataSource.query(
      'EXEC sp_insertar_cliente @id_tipo_cliente, @codigo_cliente, @nombre_comercial, @direccion_empresa, @telefono, @celular, @correo_electronico, @estado, @id_cliente_nuevo OUTPUT',
      [
        clienteData.id_tipo_cliente,
        clienteData.codigo_cliente,
        clienteData.nombre_comercial,
        clienteData.direccion_empresa || null,
        clienteData.telefono || null,
        clienteData.celular || null,
        clienteData.correo_electronico || null,
        clienteData.estado !== undefined ? clienteData.estado : 1,
      ],
    );
    return result;
  }

  async actualizar(id: number, clienteData: any) {
    await this.dataSource.query(
      'EXEC sp_actualizar_cliente @id_cliente, @id_tipo_cliente, @nombre_comercial, @direccion_empresa, @telefono, @celular, @correo_electronico, @estado',
      [
        id,
        clienteData.id_tipo_cliente,
        clienteData.nombre_comercial,
        clienteData.direccion_empresa || null,
        clienteData.telefono || null,
        clienteData.celular || null,
        clienteData.correo_electronico || null,
        clienteData.estado !== undefined ? clienteData.estado : 1,
      ],
    );
    return { success: true };
  }

  async consultar(filtros?: any) {
    const result = await this.dataSource.query(
      'EXEC sp_consultar_clientes @id_cliente, @codigo_cliente, @nombre_comercial, @id_tipo_cliente, @estado',
      [
        filtros?.id_cliente || null,
        filtros?.codigo_cliente || null,
        filtros?.nombre_comercial || null,
        filtros?.id_tipo_cliente || null,
        filtros?.estado !== undefined ? filtros.estado : null,
      ],
    );
    return result;
  }
}
