import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ReporteService } from '../reporte.service';

@Component({
  selector: 'app-reporte-list',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: `<div class="container"><div class="header"><h2>Generador de Reportes</h2></div><div class="report-section"><h3>Reporte por Fecha</h3><form [formGroup]="formPorFecha" (ngSubmit)="generarPorFecha()" class="form"><div class="form-group"><label for="fecha_inicio">Fecha Inicio</label><input type="date" id="fecha_inicio" formControlName="fecha_inicio" class="form-control" /></div><div class="form-group"><label for="fecha_fin">Fecha Fin</label><input type="date" id="fecha_fin" formControlName="fecha_fin" class="form-control" /></div><button type="submit" class="btn btn-primary" [disabled]="loading">Generar</button></form></div><div class="report-section"><h3>Reporte por Gestor</h3><form [formGroup]="formPorGestor" (ngSubmit)="generarPorGestor()" class="form"><div class="form-group"><label for="id_gestor">Gestor</label><select id="id_gestor" formControlName="id_gestor" class="form-control"><option value="">Seleccionar gestor</option><option *ngFor="let g of gestores" [value]="g.id">{{ g.nombre }}</option></select></div><button type="submit" class="btn btn-primary" [disabled]="loading">Generar</button></form></div><div class="report-section"><h3>Reporte Ganadas/Perdidas</h3><button class="btn btn-primary" (click)="generarGanadasPerdidas()" [disabled]="loading">Generar</button></div><div *ngIf="loading" class="loading">Generando reporte...</div><div *ngIf="!loading && tipoReporteActual" class="results"><h3>Resultados</h3><div *ngIf="reporteActual.length === 0" class="no-data">No hay información disponible</div><table *ngIf="reporteActual.length > 0" class="table"><thead><tr><th *ngFor="let key of (reporteActual[0] | keyvalue) | slice: 0:5">{{ key.key }}</th></tr></thead><tbody><tr *ngFor="let row of reporteActual"><td *ngFor="let key of (row | keyvalue) | slice: 0:5">{{ key.value }}</td></tr></tbody></table></div></div>`,
  styleUrls: ['./reporte-list.component.css'],
})
export class ReporteListComponent implements OnInit {
  formPorFecha: FormGroup;
  formPorGestor: FormGroup;
  loading = false;
  reporteActual: any[] = [];
  tipoReporteActual = '';
  gestores: any[] = [];

  constructor(private fb: FormBuilder, private reporteService: ReporteService) {
    this.formPorFecha = this.fb.group({
      fecha_inicio: ['', Validators.required],
      fecha_fin: ['', Validators.required],
    });
    this.formPorGestor = this.fb.group({
      id_gestor: ['', Validators.required],
    });
  }

  ngOnInit() {
    this.cargarGestores();
  }

  cargarGestores() {
    this.gestores = [
      { id: 1, nombre: 'Gestor 1' },
      { id: 2, nombre: 'Gestor 2' },
      { id: 3, nombre: 'Gestor 3' },
    ];
  }

  generarPorFecha() {
    if (this.formPorFecha.invalid) return;
    this.loading = true;
    this.tipoReporteActual = 'por_fecha';
    this.reporteService
      .oportunidadesPorFecha(
        this.formPorFecha.value.fecha_inicio,
        this.formPorFecha.value.fecha_fin,
      )
      .subscribe({
        next: (data) => {
          this.reporteActual = data;
          this.loading = false;
        },
        error: () => (this.loading = false),
      });
  }

  generarPorGestor() {
    if (this.formPorGestor.invalid) return;
    this.loading = true;
    this.tipoReporteActual = 'por_gestor';
    this.reporteService.oportunidadesPorGestor(this.formPorGestor.value.id_gestor).subscribe({
      next: (data) => {
        this.reporteActual = data;
        this.loading = false;
      },
      error: () => (this.loading = false),
    });
  }

  generarGanadasPerdidas() {
    this.loading = true;
    this.tipoReporteActual = 'ganadas_perdidas';
    this.reporteService.oportunidadesGanadas().subscribe({
      next: (data) => {
        this.reporteActual = data;
        this.loading = false;
      },
      error: () => (this.loading = false),
    });
  }
}
