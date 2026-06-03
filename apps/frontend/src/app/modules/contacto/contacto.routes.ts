import { Routes } from '@angular/router';
import { ContactoListComponent } from './contacto-list/contacto-list.component';
import { ContactoDetailComponent } from './contacto-detail/contacto-detail.component';

export const contactoRoutes: Routes = [
  { path: '', component: ContactoListComponent },
  { path: 'nuevo', component: ContactoDetailComponent },
  { path: ':id', component: ContactoDetailComponent },
  { path: ':id/editar', component: ContactoDetailComponent },
];
