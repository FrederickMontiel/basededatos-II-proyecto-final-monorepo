import { Routes } from '@angular/router';
import { LoginComponent } from './auth/login/login.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { AuthGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  {
    path: 'dashboard',
    component: DashboardComponent,
    canActivate: [AuthGuard],
  },
  {
    path: 'clientes',
    canActivate: [AuthGuard],
    loadChildren: () => import('./modules/cliente/cliente.routes').then(m => m.clienteRoutes),
  },
  {
    path: 'contactos',
    canActivate: [AuthGuard],
    loadChildren: () => import('./modules/contacto/contacto.routes').then(m => m.contactoRoutes),
  },
  {
    path: 'oportunidades',
    canActivate: [AuthGuard],
    loadChildren: () => import('./modules/oportunidad/oportunidad.routes').then(m => m.oportunidadRoutes),
  },
  {
    path: 'actividades',
    canActivate: [AuthGuard],
    loadChildren: () => import('./modules/actividad/actividad.routes').then(m => m.actividadRoutes),
  },
  {
    path: 'reportes',
    canActivate: [AuthGuard],
    loadChildren: () => import('./modules/reporte/reporte.routes').then(m => m.reporteRoutes),
  },
  { path: '**', redirectTo: '/dashboard' },
];
