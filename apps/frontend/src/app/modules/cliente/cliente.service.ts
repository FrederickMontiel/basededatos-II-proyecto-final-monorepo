import { Injectable } from '@angular/core';
import { HttpParams } from '@angular/common/http';
import { ApiService } from '../../services/api.service';

export interface Cliente {
  id_cliente?: number;
  codigo?: string;
  nombre?: string;
  direccion?: string;
  telefono?: string;
  correo?: string;
  codigo_cliente?: string;
  nombre_comercial?: string;
  direccion_empresa?: string;
  correo_electronico?: string;
  id_tipo_cliente?: number;
  estado?: number | string;
  tipo_cliente?: string;
  fecha_creacion?: string;
  total_contactos?: number;
}

@Injectable({
  providedIn: 'root',
})
export class ClienteService {
  constructor(private apiService: ApiService) {}

  listar(filters?: any) {
    let params = new HttpParams();
    if (filters) {
      if (filters.codigo) params = params.set('codigo', filters.codigo);
      if (filters.nombre) params = params.set('nombre', filters.nombre);
      if (filters.tipo) params = params.set('tipo', filters.tipo);
      if (filters.estado) params = params.set('estado', filters.estado);
    }
    return this.apiService.get<Cliente[]>('/clientes', params);
  }

  obtenerPorId(id: number) {
    return this.apiService.get<Cliente>(`/clientes/${id}`);
  }

  crear(cliente: Cliente) {
    return this.apiService.post<Cliente>('/clientes', cliente);
  }

  actualizar(id: number, cliente: Cliente) {
    return this.apiService.put<Cliente>(`/clientes/${id}`, cliente);
  }

  eliminar(id: number) {
    return this.apiService.delete<void>(`/clientes/${id}`);
  }
}
