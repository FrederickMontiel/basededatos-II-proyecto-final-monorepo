import { Controller, Get, Post, Put, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { OportunidadService } from './oportunidad.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Oportunidades')
@ApiBearerAuth()
@Controller('api/oportunidades')
@UseGuards(JwtAuthGuard)
export class OportunidadController {
  constructor(private oportunidadService: OportunidadService) {}

  @Get()
  @ApiOperation({ summary: 'Listar todas las oportunidades' })
  @ApiResponse({ status: 200, description: 'Lista de oportunidades' })
  async listar() {
    return this.oportunidadService.listar();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener oportunidad por ID' })
  @ApiResponse({ status: 200, description: 'Oportunidad encontrada' })
  async obtenerPorId(@Param('id') id: number) {
    return this.oportunidadService.obtenerPorId(id);
  }

  @Post()
  @ApiOperation({ summary: 'Crear nueva oportunidad' })
  @ApiResponse({ status: 201, description: 'Oportunidad creada exitosamente' })
  async crear(@Body() oportunidadData: any) {
    return this.oportunidadService.crear(oportunidadData);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar oportunidad' })
  @ApiResponse({ status: 200, description: 'Oportunidad actualizada exitosamente' })
  async actualizar(@Param('id') id: number, @Body() oportunidadData: any) {
    return this.oportunidadService.actualizar(id, oportunidadData);
  }

  @Patch(':id/etapa')
  @ApiOperation({ summary: 'Cambiar etapa de oportunidad' })
  @ApiResponse({ status: 200, description: 'Etapa cambiada exitosamente' })
  async cambiarEtapa(@Param('id') id: number, @Body() data: any) {
    return this.oportunidadService.cambiarEtapa(id, data.id_etapa_oportunidad);
  }

  @Patch(':id/cerrar')
  @ApiOperation({ summary: 'Cerrar oportunidad' })
  @ApiResponse({ status: 200, description: 'Oportunidad cerrada exitosamente' })
  async cerrar(@Param('id') id: number, @Body() data: any) {
    return this.oportunidadService.cerrar(
      id,
      data.id_estado_oportunidad,
      data.comentario_cierre,
    );
  }
}
