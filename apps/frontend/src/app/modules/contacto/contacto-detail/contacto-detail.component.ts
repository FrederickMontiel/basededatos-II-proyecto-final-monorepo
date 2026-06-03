import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ContactoService, Contacto } from '../contacto.service';
import { ClienteService } from '../../cliente/cliente.service';

@Component({
  selector: 'app-contacto-detail',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './contacto-detail.component.html',
  styleUrls: ['./contacto-detail.component.css'],
})
export class ContactoDetailComponent implements OnInit {
  form: FormGroup;
  loading = false;
  submitted = false;
  error = '';
  isEditing = false;
  contactoId: number | null = null;
  clientes: any[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private contactoService: ContactoService,
    private clienteService: ClienteService,
    private route: ActivatedRoute,
    private router: Router,
  ) {
    this.form = this.formBuilder.group({
      id_cliente: ['', Validators.required],
      nombre_contacto: ['', Validators.required],
      puesto_contacto: [''],
      telefono: [''],
      celular: [''],
      correo_electronico: ['', Validators.email],
      estado: [1],
    });
  }

  ngOnInit() {
    this.cargarClientes();
    this.route.params.subscribe((params) => {
      if (params['id']) {
        this.contactoId = +params['id'];
        this.isEditing = true;
        this.cargarContacto(this.contactoId!);
      }
    });
  }

  cargarClientes() {
    this.clienteService.listar().subscribe({
      next: (data) => (this.clientes = data),
    });
  }

  cargarContacto(id: number) {
    this.loading = true;
    this.contactoService.obtenerPorId(id).subscribe({
      next: (contacto) => {
        this.form.patchValue(contacto);
        this.loading = false;
      },
      error: () => {
        this.error = 'Error al cargar contacto';
        this.loading = false;
      },
    });
  }

  get f() {
    return this.form.controls;
  }

  onSubmit() {
    this.submitted = true;
    this.error = '';

    if (this.form.invalid) return;

    this.loading = true;
    const contacto = {
      ...this.form.value,
      id_cliente: parseInt(this.form.value.id_cliente),
      estado: parseInt(this.form.value.estado),
    };

    if (this.isEditing && this.contactoId) {
      this.contactoService.actualizar(this.contactoId, contacto).subscribe({
        next: () => this.router.navigate(['/contactos']),
        error: () => {
          this.error = 'Error al actualizar contacto';
          this.loading = false;
        },
      });
    } else {
      this.contactoService.crear(contacto).subscribe({
        next: () => this.router.navigate(['/contactos']),
        error: () => {
          this.error = 'Error al crear contacto';
          this.loading = false;
        },
      });
    }
  }

  cancelar() {
    this.router.navigate(['/contactos']);
  }
}
