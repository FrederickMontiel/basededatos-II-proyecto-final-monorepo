import { Routes } from '@angular/router';
import { OportunidadListComponent } from './oportunidad-list/oportunidad-list.component';
import { OportunidadDetailComponent } from './oportunidad-detail/oportunidad-detail.component';

export const oportunidadRoutes: Routes = [
  { path: '', component: OportunidadListComponent },
  { path: 'nuevo', component: OportunidadDetailComponent },
  { path: ':id', component: OportunidadDetailComponent },
  { path: ':id/editar', component: OportunidadDetailComponent },
];
