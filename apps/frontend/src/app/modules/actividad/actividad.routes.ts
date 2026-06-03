import { Routes } from '@angular/router';
import { ActividadListComponent } from './actividad-list/actividad-list.component';
import { ActividadDetailComponent } from './actividad-detail/actividad-detail.component';

export const actividadRoutes: Routes = [
  { path: '', component: ActividadListComponent },
  { path: 'nuevo', component: ActividadDetailComponent },
  { path: ':id', component: ActividadDetailComponent },
  { path: ':id/editar', component: ActividadDetailComponent },
];
