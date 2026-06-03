import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Router } from '@angular/router';
import { ApiService } from './api.service';

export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  usuario: {
    id: number;
    correo: string;
    nombres: string;
    apellidos: string;
  };
}

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private isAuthenticatedSubject = new BehaviorSubject<boolean>(this.hasToken());
  public isAuthenticated$ = this.isAuthenticatedSubject.asObservable();

  constructor(private apiService: ApiService, private router: Router) {}

  login(correo: string, password: string): Observable<LoginResponse> {
    return this.apiService.post<LoginResponse>('/auth/login', { correo, password }).pipe(
      tap((response) => {
        localStorage.setItem('access_token', response.access_token);
        localStorage.setItem('refresh_token', response.refresh_token);
        localStorage.setItem('usuario', JSON.stringify(response.usuario));
        this.isAuthenticatedSubject.next(true);
      }),
    );
  }

  logout() {
    localStorage.removeItem('access_token');
    localStorage.removeItem('refresh_token');
    localStorage.removeItem('usuario');
    this.isAuthenticatedSubject.next(false);
    this.router.navigate(['/login']);
  }

  getToken(): string | null {
    return localStorage.getItem('access_token');
  }

  getRefreshToken(): string | null {
    return localStorage.getItem('refresh_token');
  }

  getUsuario() {
    const usuario = localStorage.getItem('usuario');
    return usuario ? JSON.parse(usuario) : null;
  }

  hasToken(): boolean {
    return !!localStorage.getItem('access_token');
  }

  isAuthenticated(): boolean {
    return this.hasToken();
  }

  refresh(): Observable<LoginResponse> {
    return this.apiService.post<LoginResponse>('/auth/refresh', {}).pipe(
      tap((response) => {
        localStorage.setItem('access_token', response.access_token);
        localStorage.setItem('refresh_token', response.refresh_token);
      }),
    );
  }
}
