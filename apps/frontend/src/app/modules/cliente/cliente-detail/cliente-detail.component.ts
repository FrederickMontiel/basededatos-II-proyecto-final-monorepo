import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { forkJoin } from 'rxjs';
import { ClienteService, Cliente } from '../cliente.service';
import { CatalogoService } from '../../../services/catalogo.service';

@Component({
  selector: 'app-cliente-detail',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './cliente-detail.component.html',
  styleUrls: ['./cliente-detail.component.css'],
})
export class ClienteDetailComponent implements OnInit {
  form: FormGroup;
  loading = false;
  submitted = false;
  error = '';
  isEditing = false;
  clienteId: number | null = null;
  tiposCliente: any[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private clienteService: ClienteService,
    private catalogoService: CatalogoService,
    private route: ActivatedRoute,
    private router: Router,
  ) {
    this.form = this.formBuilder.group({
      codigo: ['', Validators.required],
      nombre: ['', Validators.required],
      direccion: ['', Validators.required],
      telefono: ['', Validators.required],
      correo: ['', [Validators.required, Validators.email]],
      id_tipo_cliente: [1, Validators.required],
      estado: [1, Validators.required],
    });
  }

  ngOnInit() {
    this.route.params.subscribe((params) => {
      if (params['id']) {
        this.clienteId = +params['id'];
        this.isEditing = true;
        forkJoin([
          this.catalogoService.getTiposCliente(),
          this.clienteService.obtenerPorId(this.clienteId!),
        ]).subscribe({
          next: ([tipos, cliente]) => {
            this.tiposCliente = tipos;
            this.form.patchValue({
              codigo: cliente.codigo_cliente,
              nombre: cliente.nombre_comercial,
              direccion: cliente.direccion_empresa,
              telefono: cliente.telefono,
              correo: cliente.correo_electronico,
              id_tipo_cliente: cliente.id_tipo_cliente,
              estado: cliente.estado,
            });
            this.loading = false;
          },
          error: () => {
            this.error = 'Error al cargar cliente';
            this.loading = false;
          },
        });
      } else {
        this.cargarTiposCliente();
      }
    });
  }

  cargarTiposCliente() {
    this.catalogoService.getTiposCliente().subscribe({
      next: (data) => (this.tiposCliente = data),
      error: () => (this.tiposCliente = []),
    });
  }

  get f() {
    return this.form.controls;
  }

  onSubmit() {
    this.submitted = true;
    this.error = '';

    if (this.form.invalid) {
      return;
    }

    this.loading = true;
    const cliente = this.form.value;

    if (this.isEditing && this.clienteId) {
      this.clienteService.actualizar(this.clienteId, cliente).subscribe({
        next: () => {
          this.router.navigate(['/clientes']);
        },
        error: () => {
          this.error = 'Error al actualizar cliente';
          this.loading = false;
        },
      });
    } else {
      this.clienteService.crear(cliente).subscribe({
        next: () => {
          this.router.navigate(['/clientes']);
        },
        error: () => {
          this.error = 'Error al crear cliente';
          this.loading = false;
        },
      });
    }
  }

  cancelar() {
    this.router.navigate(['/clientes']);
  }

  compareById(a: any, b: any): boolean {
    if (a === null || b === null) return a === b;
    return a === b;
  }
}
