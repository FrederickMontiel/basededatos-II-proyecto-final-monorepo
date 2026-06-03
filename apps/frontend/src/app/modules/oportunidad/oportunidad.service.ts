import { Injectable } from '@angular/core';
import { ApiService } from '../../services/api.service';

export interface Oportunidad {
  id_oportunidad?: number;
  numero_oportunidad?: string;
  id_cliente?: number;
  id_contacto?: number;
  nombre_oportunidad?: string;
  id_etapa_oportunidad?: number;
  id_estado_oportunidad?: number;
  monto_potencial?: number;
  estado?: number | string;
}

@Injectable({
  providedIn: 'root',
})
export class OportunidadService {
  constructor(private apiService: ApiService) {}

  listar() {
    return this.apiService.get<Oportunidad[]>('/oportunidades');
  }

  obtenerPorId(id: number) {
    return this.apiService.get<Oportunidad>(`/oportunidades/${id}`);
  }

  crear(oportunidad: Oportunidad) {
    return this.apiService.post<Oportunidad>('/oportunidades', oportunidad);
  }

  actualizar(id: number, oportunidad: Oportunidad) {
    return this.apiService.put<Oportunidad>(`/oportunidades/${id}`, oportunidad);
  }

  cambiarEtapa(id: number, idEtapa: number) {
    return this.apiService.patch(`/oportunidades/${id}/etapa`, { id_etapa_oportunidad: idEtapa });
  }

  cerrar(id: number, idEstado: number, comentario: string) {
    return this.apiService.patch(`/oportunidades/${id}/cerrar`, {
      id_estado_oportunidad: idEstado,
      comentario_cierre: comentario,
    });
  }

  eliminar(id: number) {
    return this.apiService.delete<void>(`/oportunidades/${id}`);
  }
}
