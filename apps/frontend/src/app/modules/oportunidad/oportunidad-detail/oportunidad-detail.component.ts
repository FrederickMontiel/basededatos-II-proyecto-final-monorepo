import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { OportunidadService } from '../oportunidad.service';
import { ClienteService } from '../../cliente/cliente.service';
import { ContactoService } from '../../contacto/contacto.service';
import { CatalogoService } from '../../../services/catalogo.service';

@Component({
  selector: 'app-oportunidad-detail',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './oportunidad-detail.component.html',
  styleUrls: ['./oportunidad-detail.component.css'],
})
export class OportunidadDetailComponent implements OnInit {
  form: FormGroup;
  isEditing = false;
  oportunidadId: number | null = null;
  loading = false;
  clientes: any[] = [];
  contactos: any[] = [];
  contactosFiltrados: any[] = [];
  tiposOportunidad: any[] = [];
  unidadesTiempo = ['Dias', 'Horas', 'Semanas'];
  gestores: any[] = [];
  asistentes: any[] = [];
  gerentes: any[] = [];

  constructor(
    private formBuilder: FormBuilder,
    private oportunidadService: OportunidadService,
    private clienteService: ClienteService,
    private contactoService: ContactoService,
    private catalogoService: CatalogoService,
    private route: ActivatedRoute,
    private router: Router,
  ) {
    this.form = this.formBuilder.group({
      numero_oportunidad: [{ value: '', disabled: true }],
      id_cliente: ['', Validators.required],
      id_contacto: ['', Validators.required],
      id_tipo_oportunidad: ['', Validators.required],
      id_gestor_comercial: ['', Validators.required],
      id_asistente_comercial: ['', Validators.required],
      id_gerente_comercial: ['', Validators.required],
      nombre_oportunidad: ['', Validators.required],
      monto_potencial: ['', Validators.required],
      cierre_planificado_valor: ['', Validators.required],
      cierre_planificado_unidad: ['Dias', Validators.required],
    });

    this.form.get('id_cliente')?.valueChanges.subscribe((idCliente) => {
      this.filtrarContactos(parseInt(idCliente));
    });
  }

  ngOnInit() {
    this.cargarDatos();
    this.route.params.subscribe((params) => {
      if (params['id']) {
        this.oportunidadId = +params['id'];
        this.isEditing = true;
        this.cargarOportunidad(this.oportunidadId!);
      } else {
        this.form.patchValue({ numero_oportunidad: `OPT-${Date.now()}` });
      }
    });
  }

  cargarDatos() {
    this.clienteService.listar().subscribe({
      next: (data) => (this.clientes = data),
    });
    this.contactoService.listar().subscribe({
      next: (data) => (this.contactos = data),
    });
    this.catalogoService.getTiposOportunidad().subscribe({
      next: (data) => (this.tiposOportunidad = data),
    });
    this.catalogoService.getGestores().subscribe({
      next: (data) => (this.gestores = data),
    });
    this.catalogoService.getAsistentes().subscribe({
      next: (data) => (this.asistentes = data),
    });
    this.catalogoService.getGerentes().subscribe({
      next: (data) => (this.gerentes = data),
    });
  }

  filtrarContactos(idCliente: number) {
    this.contactosFiltrados = this.contactos.filter((c) => c.id_cliente === idCliente);
    this.form.patchValue({ id_contacto: '' });
  }

  cargarOportunidad(id: number) {
    this.loading = true;
    this.oportunidadService.obtenerPorId(id).subscribe({
      next: (data) => {
        this.form.patchValue(data);
        if (data.id_cliente) this.filtrarContactos(data.id_cliente);
        this.loading = false;
      },
      error: () => (this.loading = false),
    });
  }

  onSubmit() {
    if (this.form.invalid) return;
    this.loading = true;
    const data = {
      ...this.form.getRawValue(),
      id_cliente: parseInt(this.form.value.id_cliente),
      id_contacto: parseInt(this.form.value.id_contacto),
      id_tipo_oportunidad: parseInt(this.form.value.id_tipo_oportunidad),
      id_gestor_comercial: parseInt(this.form.value.id_gestor_comercial),
      id_asistente_comercial: parseInt(this.form.value.id_asistente_comercial),
      id_gerente_comercial: parseInt(this.form.value.id_gerente_comercial),
      monto_potencial: parseFloat(this.form.value.monto_potencial),
      cierre_planificado_valor: parseInt(this.form.value.cierre_planificado_valor),
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
