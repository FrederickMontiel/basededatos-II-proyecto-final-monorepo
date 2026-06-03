import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ReportesService {
  constructor(private dataSource: DataSource) {}

  async listar() {
    return [];
  }

  async obtenerPorId(id: number) {
    return null;
  }

  async oportunidadesPorFecha(fechaInicio: string, fechaFin: string) {
    const inicio = new Date(fechaInicio).toLocaleDateString('es-ES', { year: 'numeric', month: '2-digit', day: '2-digit' }).split('/').reverse().join('-');
    const fin = new Date(fechaFin).toLocaleDateString('es-ES', { year: 'numeric', month: '2-digit', day: '2-digit' }).split('/').reverse().join('-');
    const sql = `
      DECLARE @fecha_inicio DATE = '${inicio}';
      DECLARE @fecha_fin DATE = '${fin}';
      EXEC sp_informe_oportunidades_por_fecha @fecha_inicio, @fecha_fin;
    `;
    return await this.dataSource.query(sql);
  }

  async oportunidadesPorGestor(idGestor: number) {
    const sql = `
      DECLARE @id_gestor_comercial INT = ${idGestor};
      EXEC sp_informe_oportunidades_por_gestor @id_gestor_comercial;
    `;
    return await this.dataSource.query(sql);
  }

  async oportunidadesGanadas() {
    const sql = `EXEC sp_informe_oportunidades_ganadas_perdidas;`;
    return await this.dataSource.query(sql);
  }
}
