import { Injectable } from '@angular/core';
import { HttpParams } from '@angular/common/http';
import { ApiService } from '../../services/api.service';

export interface Contacto {
  id_contacto?: number;
  id_cliente?: number;
  nombre?: string;
  nombre_contacto?: string;
  puesto?: string;
  puesto_contacto?: string;
  telefono?: string;
  celular?: string;
  correo?: string;
  correo_electronico?: string;
  estado?: number | string;
}

@Injectable({
  providedIn: 'root',
})
export class ContactoService {
  constructor(private apiService: ApiService) {}

  listar(idCliente?: number) {
    let params = new HttpParams();
    if (idCliente) params = params.set('id_cliente', idCliente);
    return this.apiService.get<Contacto[]>('/contactos', params);
  }

  obtenerPorId(id: number) {
    return this.apiService.get<Contacto>(`/contactos/${id}`);
  }

  crear(contacto: Contacto) {
    return this.apiService.post<Contacto>('/contactos', contacto);
  }

  actualizar(id: number, contacto: Contacto) {
    return this.apiService.put<Contacto>(`/contactos/${id}`, contacto);
  }

  eliminar(id: number) {
    return this.apiService.delete<void>(`/contactos/${id}`);
  }
}
