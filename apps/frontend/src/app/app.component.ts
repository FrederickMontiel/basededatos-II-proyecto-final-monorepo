import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent implements OnInit {
  title = 'Innovacion CRM';
  apiStatus = 'Conectando...';

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.checkApiHealth();
  }

  checkApiHealth() {
    this.http.get<any>('http://backend:3000/api/health')
      .subscribe({
        next: (response) => {
          this.apiStatus = `✓ API Conectada (${response.timestamp})`;
        },
        error: () => {
          this.apiStatus = '✗ Error al conectar API';
        }
      });
  }
}
