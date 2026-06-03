import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class OportunidadService {
  constructor(private dataSource: DataSource) {}

  async listar() {
    return await this.dataSource.query('SELECT * FROM oportunidad');
  }

  async obtenerPorId(id: number) {
    const result = await this.dataSource.query(`SELECT * FROM oportunidad WHERE id_oportunidad = ${id}`);
    return result[0];
  }

  async crear(oportunidadData: any) {
    console.log('Oportunidad data received:', oportunidadData);
    const sql = `
      DECLARE @numero_oportunidad VARCHAR(50) = '${this.escape(oportunidadData.numero_oportunidad)}';
      DECLARE @id_cliente INT = ${parseInt(oportunidadData.id_cliente)};
      DECLARE @id_contacto INT = ${oportunidadData.id_contacto ? parseInt(oportunidadData.id_contacto) : 'NULL'};
      DECLARE @id_tipo_oportunidad INT = ${oportunidadData.id_tipo_oportunidad ? parseInt(oportunidadData.id_tipo_oportunidad) : 1};
      DECLARE @id_etapa_oportunidad INT = ${oportunidadData.id_etapa_oportunidad ? parseInt(oportunidadData.id_etapa_oportunidad) : 1};
      DECLARE @id_gestor_comercial INT = ${oportunidadData.id_gestor_comercial ? parseInt(oportunidadData.id_gestor_comercial) : 1};
      DECLARE @id_asistente_comercial INT = ${oportunidadData.id_asistente_comercial ? parseInt(oportunidadData.id_asistente_comercial) : 'NULL'};
      DECLARE @id_gerente_comercial INT = ${oportunidadData.id_gerente_comercial ? parseInt(oportunidadData.id_gerente_comercial) : 'NULL'};
      DECLARE @nombre_oportunidad VARCHAR(255) = '${this.escape(oportunidadData.nombre_oportunidad)}';
      DECLARE @cierre_planificado_valor DECIMAL(18,2) = ${parseFloat(oportunidadData.cierre_planificado_valor) || 30};
      DECLARE @cierre_planificado_unidad VARCHAR(20) = '${this.escape(oportunidadData.cierre_planificado_unidad || 'Dias')}';
      DECLARE @monto_potencial DECIMAL(18,2) = ${parseFloat(oportunidadData.monto_potencial) || 0};
      EXEC sp_crear_oportunidad @numero_oportunidad, @id_cliente, @id_contacto, @id_tipo_oportunidad, @id_etapa_oportunidad, @id_gestor_comercial, @id_asistente_comercial, @id_gerente_comercial, @nombre_oportunidad, @cierre_planificado_valor, @cierre_planificado_unidad, @monto_potencial;
    `;
    return await this.dataSource.query(sql);
  }

  async actualizar(id: number, oportunidadData: any) {
    const sql = `
      DECLARE @id_oportunidad INT = ${id};
      DECLARE @nombre_oportunidad VARCHAR(255) = '${this.escape(oportunidadData.nombre_oportunidad)}';
      DECLARE @id_gestor_comercial INT = ${oportunidadData.id_gestor_comercial ? parseInt(oportunidadData.id_gestor_comercial) : 1};
      DECLARE @id_asistente_comercial INT = ${oportunidadData.id_asistente_comercial ? parseInt(oportunidadData.id_asistente_comercial) : 'NULL'};
      DECLARE @id_gerente_comercial INT = ${oportunidadData.id_gerente_comercial ? parseInt(oportunidadData.id_gerente_comercial) : 'NULL'};
      DECLARE @cierre_planificado_valor DECIMAL(18,2) = ${parseFloat(oportunidadData.cierre_planificado_valor) || 30};
      DECLARE @cierre_planificado_unidad VARCHAR(20) = '${this.escape(oportunidadData.cierre_planificado_unidad || 'Dias')}';
      DECLARE @monto_potencial DECIMAL(18,2) = ${parseFloat(oportunidadData.monto_potencial) || 0};
      EXEC sp_actualizar_oportunidad @id_oportunidad, @nombre_oportunidad, @id_gestor_comercial, @id_asistente_comercial, @id_gerente_comercial, @cierre_planificado_valor, @cierre_planificado_unidad, @monto_potencial;
    `;
    await this.dataSource.query(sql);
    return { success: true };
  }

  async cambiarEtapa(id: number, idEtapa: number) {
    const sql = `
      DECLARE @id_oportunidad INT = ${id};
      DECLARE @id_etapa_oportunidad INT = ${idEtapa};
      EXEC sp_cambiar_etapa_oportunidad @id_oportunidad, @id_etapa_oportunidad;
    `;
    await this.dataSource.query(sql);
    return { success: true };
  }

  async cerrar(id: number, idEstado: number, comentario: string) {
    const sql = `
      DECLARE @id_oportunidad INT = ${id};
      DECLARE @id_estado_oportunidad INT = ${idEstado};
      DECLARE @comentario_cierre VARCHAR(500) = '${this.escape(comentario)}';
      EXEC sp_cerrar_oportunidad @id_oportunidad, @id_estado_oportunidad, @comentario_cierre;
    `;
    await this.dataSource.query(sql);
    return { success: true };
  }

  private escape(str: string): string {
    return str.replace(/'/g, "''");
  }
}
