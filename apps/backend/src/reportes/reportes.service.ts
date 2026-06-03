import { Injectable } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class ReportesService {
  constructor(private dataSource: DataSource) {}

  async oportunidadesPorFecha(fechaInicio: string, fechaFin: string) {
    return await this.dataSource.query(
      'EXEC sp_informe_oportunidades_por_fecha @fecha_inicio, @fecha_fin',
      [fechaInicio, fechaFin],
    );
  }

  async oportunidadesPorGestor(idGestor: number) {
    return await this.dataSource.query(
      'EXEC sp_informe_oportunidades_por_gestor @id_gestor_comercial',
      [idGestor],
    );
  }

  async oportunidadesGanadas() {
    return await this.dataSource.query(
      'EXEC sp_informe_oportunidades_ganadas_perdidas',
      [],
    );
  }
}
