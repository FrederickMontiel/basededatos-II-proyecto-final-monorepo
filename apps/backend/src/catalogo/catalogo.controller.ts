import { Controller, Get, UseGuards } from '@nestjs/common';
import { CatalogoService } from './catalogo.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('/api/catalogos')
@UseGuards(JwtAuthGuard)
export class CatalogoController {
  constructor(private catalogoService: CatalogoService) {}

  @Get('tipos-cliente')
  async getTiposCliente() {
    return await this.catalogoService.getTiposCliente();
  }

  @Get('tipos-oportunidad')
  async getTiposOportunidad() {
    return await this.catalogoService.getTiposOportunidad();
  }

  @Get('usuarios/gestores')
  async getGestores() {
    return await this.catalogoService.getGestores();
  }

  @Get('usuarios/asistentes')
  async getAsistentes() {
    return await this.catalogoService.getAsistentes();
  }

  @Get('usuarios/gerentes')
  async getGerentes() {
    return await this.catalogoService.getGerentes();
  }
}
