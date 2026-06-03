import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
})
export class DashboardComponent implements OnInit {
  usuario: any;

  modules = [
    { name: 'Clientes', icon: '👥', path: '/clientes', description: 'Gestión de clientes' },
    {
      name: 'Contactos',
      icon: '📞',
      path: '/contactos',
      description: 'Contactos de clientes',
    },
    {
      name: 'Oportunidades',
      icon: '💼',
      path: '/oportunidades',
      description: 'Oportunidades de venta',
    },
    { name: 'Actividades', icon: '📋', path: '/actividades', description: 'Actividades' },
    { name: 'Reportes', icon: '📊', path: '/reportes', description: 'Reportes y análisis' },
  ];

  constructor(
    private authService: AuthService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.usuario = this.authService.getUsuario();
  }

  logout() {
    this.authService.logout();
    this.router.navigate(['/login']);
  }
}
