import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { OportunidadService, Oportunidad } from '../oportunidad.service';

@Component({
  selector: 'app-oportunidad-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './oportunidad-list.component.html',
  styleUrls: ['./oportunidad-list.component.css'],
})
export class OportunidadListComponent implements OnInit {
  oportunidades: Oportunidad[] = [];
  loading = true;
  error = '';

  constructor(private oportunidadService: OportunidadService, private router: Router) {}

  ngOnInit() {
    this.cargarOportunidades();
  }

  cargarOportunidades() {
    this.loading = true;
    this.oportunidadService.listar().subscribe({
      next: (data) => {
        this.oportunidades = data;
        this.loading = false;
      },
      error: () => {
        this.error = 'Error al cargar oportunidades';
        this.loading = false;
      },
    });
  }

  crear() {
    this.router.navigate(['/oportunidades/nuevo']);
  }

  editar(id: number) {
    this.router.navigate(['/oportunidades', id, 'editar']);
  }

  eliminar(id: number) {
    if (confirm('¿Deseas eliminar esta oportunidad?')) {
      this.oportunidadService.eliminar(id).subscribe({
        next: () => this.cargarOportunidades(),
        error: () => (this.error = 'Error al eliminar oportunidad'),
      });
    }
  }

  ver(id: number) {
    this.router.navigate(['/oportunidades', id]);
  }
}
