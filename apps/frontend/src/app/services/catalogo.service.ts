import { Injectable } from '@angular/core';
import { ApiService } from './api.service';

@Injectable({
  providedIn: 'root',
})
export class CatalogoService {
  constructor(private apiService: ApiService) {}

  getTiposCliente() {
    return this.apiService.get<any[]>('/catalogos/tipos-cliente');
  }

  getTiposOportunidad() {
    return this.apiService.get<any[]>('/catalogos/tipos-oportunidad');
  }

  getGestores() {
    return this.apiService.get<any[]>('/catalogos/usuarios/gestores');
  }

  getAsistentes() {
    return this.apiService.get<any[]>('/catalogos/usuarios/asistentes');
  }

  getGerentes() {
    return this.apiService.get<any[]>('/catalogos/usuarios/gerentes');
  }
}
