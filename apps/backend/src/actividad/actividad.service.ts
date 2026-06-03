import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ActividadService {
  constructor(private dataSource: DataSource) {}

  async registrar(actividadData: any) {
    return await this.dataSource.query(
      'EXEC sp_registrar_actividad @id_actividad, @numero_actividad, @id_cliente, @id_contacto, @id_oportunidad, @id_usuario_responsable, @id_tipo_actividad, @id_prioridad_actividad, @id_estado_actividad, @id_finalizacion_actividad, @asunto, @fecha_actividad, @hora_inicio, @hora_final, @comentario',
      [
        actividadData.id_actividad,
        actividadData.numero_actividad,
        actividadData.id_cliente,
        actividadData.id_contacto || null,
        actividadData.id_oportunidad || null,
        actividadData.id_usuario_responsable,
        actividadData.id_tipo_actividad,
        actividadData.id_prioridad_actividad,
        actividadData.id_estado_actividad || null,
        actividadData.id_finalizacion_actividad || null,
        actividadData.asunto,
        actividadData.fecha_actividad,
        actividadData.hora_inicio,
        actividadData.hora_final || null,
        actividadData.comentario || null,
      ],
    );
  }

  async actualizar(id: number, actividadData: any) {
    await this.dataSource.query(
      'EXEC sp_actualizar_actividad @id_actividad, @id_tipo_actividad, @id_prioridad_actividad, @id_estado_actividad, @id_finalizacion_actividad, @asunto, @fecha_actividad, @hora_inicio, @hora_final, @comentario',
      [
        id,
        actividadData.id_tipo_actividad,
        actividadData.id_prioridad_actividad,
        actividadData.id_estado_actividad || null,
        actividadData.id_finalizacion_actividad || null,
        actividadData.asunto,
        actividadData.fecha_actividad,
        actividadData.hora_inicio,
        actividadData.hora_final || null,
        actividadData.comentario || null,
      ],
    );
    return { success: true };
  }

  async cerrar(id: number, comentarioCierre: string) {
    await this.dataSource.query(
      'EXEC sp_cerrar_actividad @id_actividad, @comentario_cierre',
      [id, comentarioCierre],
    );
    return { success: true };
  }

  async consultarPorCliente(idCliente: number) {
    return await this.dataSource.query(
      'EXEC sp_consultar_actividades_por_cliente @id_cliente',
      [idCliente],
    );
  }

  async consultarPorOportunidad(idOportunidad: number) {
    return await this.dataSource.query(
      'EXEC sp_consultar_actividades_por_oportunidad @id_oportunidad',
      [idOportunidad],
    );
  }
}
