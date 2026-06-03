import { Injectable } from '@angular/core';
import { ApiService } from '../../services/api.service';

export interface Reporte {
  id_reporte?: number;
  nombre_reporte?: string;
  tipo_reporte?: string;
  fecha_generacion?: string;
  [key: string]: any;
}

@Injectable({
  providedIn: 'root',
})
export class ReporteService {
  constructor(private apiService: ApiService) {}

  listar() {
    return this.apiService.get<Reporte[]>('/reportes');
  }

  eliminar(id: number) {
    return this.apiService.delete(`/reportes/${id}`);
  }

  descargar(id: number) {
    return this.apiService.get(`/reportes/${id}/descargar`);
  }

  oportunidadesPorFecha(fechaInicio: string, fechaFin: string) {
    return this.apiService.get<Reporte[]>(
      `/reportes/oportunidades/por-fecha?fecha_inicio=${fechaInicio}&fecha_fin=${fechaFin}`
    );
  }

  oportunidadesPorGestor(idGestor: number) {
    return this.apiService.get<Reporte[]>(`/reportes/oportunidades/por-gestor/${idGestor}`);
  }

  oportunidadesGanadas() {
    return this.apiService.get<Reporte[]>('/reportes/oportunidades/ganadas-perdidas');
  }
}
