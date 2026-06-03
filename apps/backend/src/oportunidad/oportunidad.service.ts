import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class OportunidadService {
  constructor(private dataSource: DataSource) {}

  async crear(oportunidadData: any) {
    return await this.dataSource.query(
      'EXEC sp_crear_oportunidad @numero_oportunidad, @id_cliente, @id_contacto, @id_tipo_oportunidad, @id_etapa_oportunidad, @id_gestor_comercial, @id_asistente_comercial, @id_gerente_comercial, @nombre_oportunidad, @cierre_planificado_valor, @cierre_planificado_unidad, @monto_potencial',
      [
        oportunidadData.numero_oportunidad,
        oportunidadData.id_cliente,
        oportunidadData.id_contacto,
        oportunidadData.id_tipo_oportunidad,
        oportunidadData.id_etapa_oportunidad,
        oportunidadData.id_gestor_comercial,
        oportunidadData.id_asistente_comercial || null,
        oportunidadData.id_gerente_comercial || null,
        oportunidadData.nombre_oportunidad,
        oportunidadData.cierre_planificado_valor,
        oportunidadData.cierre_planificado_unidad,
        oportunidadData.monto_potencial,
      ],
    );
  }

  async actualizar(id: number, oportunidadData: any) {
    await this.dataSource.query(
      'EXEC sp_actualizar_oportunidad @id_oportunidad, @nombre_oportunidad, @id_gestor_comercial, @id_asistente_comercial, @id_gerente_comercial, @cierre_planificado_valor, @cierre_planificado_unidad, @monto_potencial',
      [
        id,
        oportunidadData.nombre_oportunidad,
        oportunidadData.id_gestor_comercial,
        oportunidadData.id_asistente_comercial || null,
        oportunidadData.id_gerente_comercial || null,
        oportunidadData.cierre_planificado_valor,
        oportunidadData.cierre_planificado_unidad,
        oportunidadData.monto_potencial,
      ],
    );
    return { success: true };
  }

  async cambiarEtapa(id: number, idEtapa: number) {
    await this.dataSource.query(
      'EXEC sp_cambiar_etapa_oportunidad @id_oportunidad, @id_etapa_oportunidad',
      [id, idEtapa],
    );
    return { success: true };
  }

  async cerrar(id: number, idEstado: number, comentario: string) {
    await this.dataSource.query(
      'EXEC sp_cerrar_oportunidad @id_oportunidad, @id_estado_oportunidad, @comentario_cierre',
      [id, idEstado, comentario],
    );
    return { success: true };
  }
}
