import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ContactoService {
  constructor(private dataSource: DataSource) {}

  async insertar(contactoData: any) {
    return await this.dataSource.query(
      'EXEC sp_insertar_contacto @id_cliente, @nombre_contacto, @puesto_contacto, @telefono, @celular, @correo_electronico, @estado, @id_contacto_nuevo OUTPUT',
      [
        contactoData.id_cliente,
        contactoData.nombre_contacto,
        contactoData.puesto_contacto || null,
        contactoData.telefono || null,
        contactoData.celular || null,
        contactoData.correo_electronico || null,
        contactoData.estado !== undefined ? contactoData.estado : 1,
      ],
    );
  }

  async actualizar(id: number, contactoData: any) {
    await this.dataSource.query(
      'EXEC sp_actualizar_contacto @id_contacto, @id_cliente, @nombre_contacto, @puesto_contacto, @telefono, @celular, @correo_electronico, @estado',
      [
        id,
        contactoData.id_cliente,
        contactoData.nombre_contacto,
        contactoData.puesto_contacto || null,
        contactoData.telefono || null,
        contactoData.celular || null,
        contactoData.correo_electronico || null,
        contactoData.estado !== undefined ? contactoData.estado : 1,
      ],
    );
    return { success: true };
  }

  async consultarPorCliente(idCliente: number, estado?: number) {
    return await this.dataSource.query(
      'EXEC sp_consultar_contactos_por_cliente @id_cliente, @estado',
      [idCliente, estado !== undefined ? estado : null],
    );
  }
}
