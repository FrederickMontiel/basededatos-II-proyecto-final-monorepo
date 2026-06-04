import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Location } from '@angular/common';
import { ActividadService } from '../actividad.service';
import { ClienteService } from '../../cliente/cliente.service';

@Component({
  selector: 'app-actividad-detail',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: `<div class="container"><form [formGroup]="form" (ngSubmit)="onSubmit()"><select formControlName="id_cliente" class="form-control"><option value="">Seleccionar cliente</option><option *ngFor="let c of clientes" [value]="c.id_cliente">{{ c.nombre_comercial }}</option></select><input type="text" formControlName="asunto" placeholder="Asunto" class="form-control" /><input type="date" formControlName="fecha_actividad" class="form-control" /><input type="time" formControlName="hora_inicio" class="form-control" /><div class="form-actions"><button type="submit" class="btn btn-primary">{{ isEditing ? 'Actualizar' : 'Crear' }}</button><button type="button" class="btn btn-secondary" (click)="cancelar()">Cancelar</button></div></form></div>`,
  styleUrls: ['./actividad-detail.component.css'],
})
export class ActividadDetailComponent implements OnInit {
  form: FormGroup;
  isEditing = false;
  actividadId: number | null = null;
  loading = false;
  clientes: any[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private actividadService: ActividadService,
    private clienteService: ClienteService,
    private route: ActivatedRoute,
    private router: Router,
    private location: Location,
  ) {
    this.form = this.formBuilder.group({
      id_cliente: ['', Validators.required],
      asunto: ['', Validators.required],
      fecha_actividad: ['', Validators.required],
      hora_inicio: ['', Validators.required],
    });
  }

  ngOnInit() {
    this.cargarClientes();
    this.route.params.subscribe((params) => {
      if (params['id']) {
        this.actividadId = +params['id'];
        this.isEditing = true;
        this.cargarActividad(this.actividadId!);
      }
    });
  }

  cargarClientes() {
    this.clienteService.listar().subscribe({
      next: (data) => (this.clientes = data),
    });
  }

  cargarActividad(id: number) {
    this.loading = true;
    this.actividadService.obtenerPorId(id).subscribe({
      next: (data) => {
        this.form.patchValue(data);
        this.loading = false;
      },
      error: () => (this.loading = false),
    });
  }

  onSubmit() {
    if (this.form.invalid) return;
    const data = {
      ...this.form.value,
      id_cliente: parseInt(this.form.value.id_cliente),
    };
    if (this.isEditing && this.actividadId) {
      this.actividadService.actualizar(this.actividadId, data).subscribe({
        next: () => this.router.navigate(['/actividades']),
      });
    } else {
      this.actividadService.crear(data).subscribe({
        next: () => this.router.navigate(['/actividades']),
      });
    }
  }

  cancelar() {
    this.location.back();
  }
}
