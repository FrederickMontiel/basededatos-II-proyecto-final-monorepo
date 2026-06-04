import { Injectable } from '@angular/core';
import { ApiService } from '../../services/api.service';

export interface Actividad {
  id_actividad?: number;
  numero_actividad?: string;
  id_cliente?: number;
  id_contacto?: number;
  id_oportunidad?: number;
  id_usuario_responsable?: number;
  asunto?: string;
  fecha_actividad?: string;
  hora_inicio?: string;
  hora_final?: string;
  estado?: number | string;
}

@Injectable({
  providedIn: 'root',
})
export class ActividadService {
  constructor(private apiService: ApiService) {}

  listar() {
    return this.apiService.get<Actividad[]>('/actividades');
  }

  obtenerPorId(id: number) {
    return this.apiService.get<Actividad>(`/actividades/${id}`);
  }

  crear(actividad: Actividad) {
    return this.apiService.post<Actividad>('/actividades', actividad);
  }

  actualizar(id: number, actividad: Actividad) {
    return this.apiService.put<Actividad>(`/actividades/${id}`, actividad);
  }

  cerrar(id: number, comentario: string) {
    return this.apiService.patch(`/actividades/${id}/cerrar`, { comentario_cierre: comentario });
  }

  eliminar(id: number) {
    return this.apiService.delete<void>(`/actividades/${id}`);
  }

  listarPorOportunidad(idOportunidad: number) {
    return this.apiService.get<Actividad[]>(`/actividades/oportunidad/${idOportunidad}`);
  }
}
