import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router, ActivatedRoute } from '@angular/router';
import { ActividadService } from '../../actividad/actividad.service';
import { OportunidadService } from '../oportunidad.service';

@Component({
  selector: 'app-oportunidad-actividades',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './oportunidad-actividades.component.html',
  styleUrls: ['./oportunidad-actividades.component.css'],
})
export class OportunidadActividadesComponent implements OnInit {
  oportunidadId: number | null = null;
  oportunidad: any = null;
  actividades: any[] = [];
  loading = true;
  error = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private oportunidadService: OportunidadService,
    private actividadService: ActividadService,
  ) {}

  ngOnInit() {
    this.route.params.subscribe((params) => {
      this.oportunidadId = +params['id'];
      this.cargarOportunidad();
      this.cargarActividades();
    });
  }

  cargarOportunidad() {
    if (!this.oportunidadId) return;
    this.oportunidadService.obtenerPorId(this.oportunidadId).subscribe({
      next: (data) => (this.oportunidad = data),
      error: () => (this.error = 'Error al cargar oportunidad'),
    });
  }

  cargarActividades() {
    if (!this.oportunidadId) return;
    this.loading = true;
    this.actividadService.listarPorOportunidad(this.oportunidadId).subscribe({
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

  crearActividad() {
    if (this.oportunidadId) {
      this.router.navigate(['/actividades/nuevo'], {
        queryParams: { id_oportunidad: this.oportunidadId },
      });
    }
  }

  editar(id: number) {
    this.router.navigate(['/actividades', id, 'editar']);
  }

  eliminar(id: number) {
    if (confirm('¿Deseas eliminar esta actividad?')) {
      this.actividadService.eliminar(id).subscribe({
        next: () => this.cargarActividades(),
        error: () => (this.error = 'Error al eliminar actividad'),
      });
    }
  }

  volver() {
    this.router.navigate(['/oportunidades']);
  }
}
