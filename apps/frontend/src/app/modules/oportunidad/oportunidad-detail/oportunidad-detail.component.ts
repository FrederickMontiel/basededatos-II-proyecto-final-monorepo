import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { OportunidadService } from '../oportunidad.service';
import { ClienteService } from '../../cliente/cliente.service';

@Component({
  selector: 'app-oportunidad-detail',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  template: `<div class="container"><div class="header"><h2>{{ isEditing ? 'Editar' : 'Nueva' }} Oportunidad</h2></div><form [formGroup]="form" (ngSubmit)="onSubmit()" class="form"><input type="text" formControlName="numero_oportunidad" placeholder="Número" class="form-control" /><select formControlName="id_cliente" class="form-control"><option value="">Seleccionar cliente</option><option *ngFor="let c of clientes" [value]="c.id_cliente">{{ c.nombre_comercial }}</option></select><input type="text" formControlName="nombre_oportunidad" placeholder="Nombre" class="form-control" /><input type="number" formControlName="monto_potencial" placeholder="Monto" class="form-control" /><div class="form-actions"><button type="submit" class="btn btn-primary">{{ isEditing ? 'Actualizar' : 'Crear' }}</button><button type="button" class="btn btn-secondary" (click)="cancelar()">Cancelar</button></div></form></div>`,
  styleUrls: ['./oportunidad-detail.component.css'],
})
export class OportunidadDetailComponent implements OnInit {
  form: FormGroup;
  isEditing = false;
  oportunidadId: number | null = null;
  loading = false;
  clientes: any[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private oportunidadService: OportunidadService,
    private clienteService: ClienteService,
    private route: ActivatedRoute,
    private router: Router,
  ) {
    this.form = this.formBuilder.group({
      numero_oportunidad: ['', Validators.required],
      id_cliente: ['', Validators.required],
      nombre_oportunidad: ['', Validators.required],
      monto_potencial: ['', Validators.required],
    });
  }

  ngOnInit() {
    this.cargarClientes();
    this.route.params.subscribe((params) => {
      if (params['id']) {
        this.oportunidadId = +params['id'];
        this.isEditing = true;
        this.cargarOportunidad(this.oportunidadId!);
      }
    });
  }

  cargarClientes() {
    this.clienteService.listar().subscribe({
      next: (data) => (this.clientes = data),
    });
  }

  cargarOportunidad(id: number) {
    this.loading = true;
    this.oportunidadService.obtenerPorId(id).subscribe({
      next: (data) => {
        this.form.patchValue(data);
        this.loading = false;
      },
      error: () => (this.loading = false),
    });
  }

  onSubmit() {
    if (this.form.invalid) return;
    this.loading = true;
    const data = {
      ...this.form.value,
      id_cliente: parseInt(this.form.value.id_cliente),
      monto_potencial: parseFloat(this.form.value.monto_potencial),
    };
    if (this.isEditing && this.oportunidadId) {
      this.oportunidadService.actualizar(this.oportunidadId, data).subscribe({
        next: () => this.router.navigate(['/oportunidades']),
        error: () => (this.loading = false),
      });
    } else {
      this.oportunidadService.crear(data).subscribe({
        next: () => this.router.navigate(['/oportunidades']),
        error: () => (this.loading = false),
      });
    }
  }

  cancelar() {
    this.router.navigate(['/oportunidades']);
  }
}
