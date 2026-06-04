import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { OportunidadService, Oportunidad } from '../oportunidad.service';

interface Fase {
  titulo: string;
  etapas: number[];
  oportunidades: Oportunidad[];
  color: string;
}

@Component({
  selector: 'app-oportunidad-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './oportunidad-list.component.html',
  styleUrls: ['./oportunidad-list.component.css'],
})
export class OportunidadListComponent implements OnInit {
  oportunidades: Oportunidad[] = [];
  fases: Fase[] = [
    { titulo: 'Fase 1: Prospecting', etapas: [1, 2, 3], oportunidades: [], color: '#3498db' },
    { titulo: 'Fase 2: Negotiation', etapas: [4, 5], oportunidades: [], color: '#f39c12' },
    { titulo: 'Fase 3: Closed', etapas: [6], oportunidades: [], color: '#27ae60' },
  ];
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
        this.agruparPorFase();
        this.loading = false;
      },
      error: () => {
        this.error = 'Error al cargar oportunidades';
        this.loading = false;
      },
    });
  }

  agruparPorFase() {
    this.fases.forEach(fase => (fase.oportunidades = []));
    this.oportunidades.forEach(opp => {
      const fase = this.fases.find(f => f.etapas.includes(opp.id_etapa_oportunidad || 0));
      if (fase) fase.oportunidades.push(opp);
    });
  }

  cambiarEtapa(id: number, idFaseActual: number, direccion: 'siguiente' | 'anterior') {
    const faseActual = this.fases[idFaseActual];
    const faseNueva = direccion === 'siguiente' ? this.fases[idFaseActual + 1] : this.fases[idFaseActual - 1];
    if (!faseNueva) return;

    const idEtagaNueva = faseNueva.etapas[0];
    this.oportunidadService.cambiarEtapa(id, idEtagaNueva).subscribe({
      next: () => this.cargarOportunidades(),
      error: () => (this.error = 'Error al cambiar etapa'),
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
