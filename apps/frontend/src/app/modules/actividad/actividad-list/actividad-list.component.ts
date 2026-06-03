import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { ActividadService, Actividad } from '../actividad.service';

@Component({
  selector: 'app-actividad-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  template: `<div class="container"><div class="header"><h2>Actividades</h2><button class="btn btn-primary" (click)="crear()">+ Nueva</button></div><div *ngIf="error" class="alert">{{ error }}</div><div *ngIf="loading">Cargando...</div><table *ngIf="!loading && actividades.length" class="table"><thead><tr><th>Asunto</th><th>Fecha</th><th>Acciones</th></tr></thead><tbody><tr *ngFor="let a of actividades"><td>{{ a.asunto }}</td><td>{{ a.fecha_actividad }}</td><td><button class="btn btn-sm" (click)="ver(a.id_actividad!)">Ver</button> <button class="btn btn-sm" (click)="editar(a.id_actividad!)">Editar</button> <button class="btn btn-sm" (click)="eliminar(a.id_actividad!)">Eliminar</button></td></tr></tbody></table></div>`,
  styleUrls: ['./actividad-list.component.css'],
})
export class ActividadListComponent implements OnInit {
  actividades: Actividad[] = [];
  loading = true;
  error = '';

  constructor(private actividadService: ActividadService, private router: Router) {}

  ngOnInit() {
    this.cargarActividades();
  }

  cargarActividades() {
    this.loading = true;
    this.actividadService.listar().subscribe({
      next: (data) => {
        this.actividades = data;
        this.loading = false;
      },
      error: () => {
        this.error = 'Error al cargar actividades';
        this.loading = false;
      },
    });
  }

  crear() {
    this.router.navigate(['/actividades/nuevo']);
  }

  editar(id: number) {
    this.router.navigate(['/actividades', id, 'editar']);
  }

  eliminar(id: number) {
    if (confirm('¿Eliminar?')) {
      this.actividadService.eliminar(id).subscribe({
        next: () => this.cargarActividades(),
        error: () => (this.error = 'Error'),
      });
    }
  }

  ver(id: number) {
    this.router.navigate(['/actividades', id]);
  }
}
