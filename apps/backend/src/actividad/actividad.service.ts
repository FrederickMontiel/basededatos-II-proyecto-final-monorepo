import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ActividadService {
  constructor(private dataSource: DataSource) {}

  async listar() {
    return await this.dataSource.query('SELECT * FROM actividad');
  }

  async obtenerPorId(id: number) {
    const result = await this.dataSource.query(`SELECT * FROM actividad WHERE id_actividad = ${id}`);
    return result[0];
  }

  async registrar(actividadData: any) {
    console.log('STEP 1 - Actividad data received:', actividadData);

    const numeroActividad = actividadData.numero_actividad || `ACT-${Date.now()}`;
    const idCliente = actividadData.id_cliente ? parseInt(actividadData.id_cliente) : 1;
    const idContacto = actividadData.id_contacto ? parseInt(actividadData.id_contacto) : null;
    const idOportunidad = actividadData.id_oportunidad ? parseInt(actividadData.id_oportunidad) : null;
    const idUsuarioResponsable = actividadData.id_usuario_responsable ? parseInt(actividadData.id_usuario_responsable) : 1;
    const idTipoActividad = actividadData.id_tipo_actividad ? parseInt(actividadData.id_tipo_actividad) : 1;
    const idPrioridadActividad = actividadData.id_prioridad_actividad ? parseInt(actividadData.id_prioridad_actividad) : 1;
    const idEstadoActividad = actividadData.id_estado_actividad ? parseInt(actividadData.id_estado_actividad) : null;
    const idFinalizacionActividad = actividadData.id_finalizacion_actividad ? parseInt(actividadData.id_finalizacion_actividad) : null;

    console.log('STEP 2 - Variables assigned:', {
      numeroActividad, idCliente, idContacto, idOportunidad, idUsuarioResponsable,
      idTipoActividad, idPrioridadActividad, idEstadoActividad, idFinalizacionActividad
    });

    const sql = `
      DECLARE @numero_actividad VARCHAR(50) = '${this.escape(numeroActividad)}';
      DECLARE @id_cliente INT = ${idCliente};
      DECLARE @id_contacto INT = ${idContacto !== null ? idContacto : 'NULL'};
      DECLARE @id_oportunidad INT = ${idOportunidad !== null ? idOportunidad : 'NULL'};
      DECLARE @id_usuario_responsable INT = ${idUsuarioResponsable};
      DECLARE @id_tipo_actividad INT = ${idTipoActividad};
      DECLARE @id_prioridad_actividad INT = ${idPrioridadActividad};
      DECLARE @id_estado_actividad INT = ${idEstadoActividad !== null ? idEstadoActividad : 'NULL'};
      DECLARE @id_finalizacion_actividad INT = ${idFinalizacionActividad !== null ? idFinalizacionActividad : 'NULL'};
      DECLARE @asunto VARCHAR(255) = '${this.escape(actividadData.asunto)}';
      DECLARE @fecha_actividad DATE = '${actividadData.fecha_actividad}';
      DECLARE @hora_inicio TIME = '${actividadData.hora_inicio}';
      DECLARE @hora_final TIME = ${actividadData.hora_final ? `'${actividadData.hora_final}'` : 'NULL'};
      DECLARE @comentario VARCHAR(500) = ${actividadData.comentario ? `'${this.escape(actividadData.comentario)}'` : 'NULL'};
      EXEC sp_registrar_actividad @numero_actividad, @id_cliente, @id_contacto, @id_oportunidad, @id_usuario_responsable, @id_tipo_actividad, @id_prioridad_actividad, @id_estado_actividad, @id_finalizacion_actividad, @asunto, @fecha_actividad, @hora_inicio, @hora_final, @comentario;
    `;

    const insertSql = `
      INSERT INTO dbo.actividad (
        numero_actividad,
        id_cliente,
        id_contacto,
        id_oportunidad,
        id_usuario_responsable,
        id_tipo_actividad,
        id_prioridad_actividad,
        id_estado_actividad,
        id_finalizacion_actividad,
        asunto,
        fecha_actividad,
        hora_inicio,
        hora_final,
        comentario
      ) VALUES (
        '${this.escape(numeroActividad)}',
        ${idCliente},
        ${idContacto !== null ? idContacto : 'NULL'},
        ${idOportunidad !== null ? idOportunidad : 'NULL'},
        ${idUsuarioResponsable},
        ${idTipoActividad},
        ${idPrioridadActividad},
        ${idEstadoActividad !== null ? idEstadoActividad : 'NULL'},
        ${idFinalizacionActividad !== null ? idFinalizacionActividad : 'NULL'},
        '${this.escape(actividadData.asunto)}',
        '${actividadData.fecha_actividad}',
        '${actividadData.hora_inicio}',
        ${actividadData.hora_final ? `'${actividadData.hora_final}'` : 'NULL'},
        ${actividadData.comentario ? `'${this.escape(actividadData.comentario)}'` : 'NULL'}
      );
    `;

    console.log('STEP 3 - INSERT Query:', insertSql);

    try {
      const result = await this.dataSource.query(insertSql);
      console.log('STEP 4 - Query success:', result);
      return result;
    } catch (error) {
      console.log('STEP 4 - Query error:', error.message);
      throw error;
    }
  }

  async actualizar(id: number, actividadData: any) {
    const sql = `
      DECLARE @id_actividad INT = ${id};
      DECLARE @id_tipo_actividad INT = ${actividadData.id_tipo_actividad};
      DECLARE @id_prioridad_actividad INT = ${actividadData.id_prioridad_actividad};
      DECLARE @id_estado_actividad INT = ${actividadData.id_estado_actividad || 'NULL'};
      DECLARE @id_finalizacion_actividad INT = ${actividadData.id_finalizacion_actividad || 'NULL'};
      DECLARE @asunto VARCHAR(255) = '${this.escape(actividadData.asunto)}';
      DECLARE @fecha_actividad DATE = '${actividadData.fecha_actividad}';
      DECLARE @hora_inicio TIME = '${actividadData.hora_inicio}';
      DECLARE @hora_final TIME = ${actividadData.hora_final ? `'${actividadData.hora_final}'` : 'NULL'};
      DECLARE @comentario VARCHAR(500) = ${actividadData.comentario ? `'${this.escape(actividadData.comentario)}'` : 'NULL'};
      EXEC sp_actualizar_actividad @id_actividad, @id_tipo_actividad, @id_prioridad_actividad, @id_estado_actividad, @id_finalizacion_actividad, @asunto, @fecha_actividad, @hora_inicio, @hora_final, @comentario;
    `;
    await this.dataSource.query(sql);
    return { success: true };
  }

  async cerrar(id: number, comentarioCierre: string) {
    const sql = `
      DECLARE @id_actividad INT = ${id};
      DECLARE @comentario_cierre VARCHAR(500) = '${this.escape(comentarioCierre)}';
      EXEC sp_cerrar_actividad @id_actividad, @comentario_cierre;
    `;
    await this.dataSource.query(sql);
    return { success: true };
  }

  async consultarPorCliente(idCliente: number) {
    const sql = `
      DECLARE @id_cliente INT = ${idCliente};
      EXEC sp_consultar_actividades_por_cliente @id_cliente;
    `;
    return await this.dataSource.query(sql);
  }

  async consultarPorOportunidad(idOportunidad: number) {
    const sql = `
      DECLARE @id_oportunidad INT = ${idOportunidad};
      EXEC sp_consultar_actividades_por_oportunidad @id_oportunidad;
    `;
    return await this.dataSource.query(sql);
  }

  private escape(str: string): string {
    return str.replace(/'/g, "''");
  }
}
