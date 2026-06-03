import { Controller, Get, Post, Put, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { ActividadService } from './actividad.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Actividades')
@ApiBearerAuth()
@Controller('api/actividades')
@UseGuards(JwtAuthGuard)
export class ActividadController {
  constructor(private actividadService: ActividadService) {}

  @Post()
  @ApiOperation({ summary: 'Registrar nueva actividad' })
  @ApiResponse({ status: 201, description: 'Actividad registrada exitosamente' })
  async registrar(@Body() actividadData: any) {
    return this.actividadService.registrar(actividadData);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar actividad' })
  @ApiResponse({ status: 200, description: 'Actividad actualizada exitosamente' })
  async actualizar(@Param('id') id: number, @Body() actividadData: any) {
    return this.actividadService.actualizar(id, actividadData);
  }

  @Patch(':id/cerrar')
  @ApiOperation({ summary: 'Cerrar actividad' })
  @ApiResponse({ status: 200, description: 'Actividad cerrada exitosamente' })
  async cerrar(@Param('id') id: number, @Body() data: any) {
    return this.actividadService.cerrar(id, data.comentario_cierre);
  }

  @Get('cliente/:idCliente')
  @ApiOperation({ summary: 'Obtener actividades de un cliente' })
  @ApiResponse({ status: 200, description: 'Lista de actividades' })
  async porCliente(@Param('idCliente') idCliente: number) {
    return this.actividadService.consultarPorCliente(idCliente);
  }

  @Get('oportunidad/:idOportunidad')
  @ApiOperation({ summary: 'Obtener actividades de una oportunidad' })
  @ApiResponse({ status: 200, description: 'Lista de actividades' })
  async porOportunidad(@Param('idOportunidad') idOportunidad: number) {
    return this.actividadService.consultarPorOportunidad(idOportunidad);
  }
}
