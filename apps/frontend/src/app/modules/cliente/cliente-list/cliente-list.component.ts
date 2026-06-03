import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Router } from '@angular/router';
import { ClienteService, Cliente } from '../cliente.service';

@Component({
  selector: 'app-cliente-list',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './cliente-list.component.html',
  styleUrls: ['./cliente-list.component.css'],
})
export class ClienteListComponent implements OnInit {
  clientes: Cliente[] = [];
  loading = true;
  error = '';

  constructor(
    private clienteService: ClienteService,
    private router: Router,
  ) {}

  ngOnInit() {
    this.cargarClientes();
  }

  cargarClientes() {
    this.loading = true;
    this.error = '';
    this.clienteService.listar().subscribe({
      next: (data) => {
        this.clientes = data;
        this.loading = false;
      },
      error: (err) => {
        this.error = 'Error al cargar clientes';
        this.loading = false;
      },
    });
  }

  crear() {
    this.router.navigate(['/clientes/nuevo']);
  }

  editar(id: number) {
    this.router.navigate(['/clientes', id, 'editar']);
  }

  eliminar(id: number) {
    if (confirm('¿Deseas eliminar este cliente?')) {
      this.clienteService.eliminar(id).subscribe({
        next: () => {
          this.cargarClientes();
        },
        error: () => {
          this.error = 'Error al eliminar cliente';
        },
      });
    }
  }

  ver(id: number) {
    this.router.navigate(['/clientes', id]);
  }
}
