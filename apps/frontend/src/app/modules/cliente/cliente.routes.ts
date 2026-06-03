import { Routes } from '@angular/router';
import { ClienteListComponent } from './cliente-list/cliente-list.component';
import { ClienteDetailComponent } from './cliente-detail/cliente-detail.component';

export const clienteRoutes: Routes = [
  { path: '', component: ClienteListComponent },
  { path: 'nuevo', component: ClienteDetailComponent },
  { path: ':id', component: ClienteDetailComponent },
  { path: ':id/editar', component: ClienteDetailComponent },
];
