import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { ContactoService, Contacto } from '../contacto.service';

@Component({
  selector: 'app-contacto-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './contacto-list.component.html',
  styleUrls: ['./contacto-list.component.css'],
})
export class ContactoListComponent implements OnInit {
  contactos: Contacto[] = [];
  loading = true;
  error = '';

  constructor(
    private contactoService: ContactoService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.cargarContactos();
  }

  cargarContactos() {
    this.loading = true;
    this.error = '';
    this.contactoService.listar().subscribe({
      next: (data) => {
        this.contactos = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al cargar contactos';
        this.loading = false;
      },
    });
  }

  crear() {
    this.router.navigate(['/contactos/nuevo']);
  }

  editar(id: number) {
    this.router.navigate(['/contactos', id, 'editar']);
  }

  eliminar(id: number) {
    if (confirm('¿Deseas eliminar este contacto?')) {
      this.contactoService.eliminar(id).subscribe({
        next: () => this.cargarContactos(),
        error: () => (this.error = 'Error al eliminar contacto'),
      });
    }
  }

  ver(id: number) {
    this.router.navigate(['/contactos', id]);
  }
}
