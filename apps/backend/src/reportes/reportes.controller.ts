import { Controller, Get, Query, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { ReportesService } from './reportes.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Reportes')
@ApiBearerAuth()
@Controller('api/reportes')
@UseGuards(JwtAuthGuard)
export class ReportesController {
  constructor(private reportesService: ReportesService) {}

  @Get()
  @ApiOperation({ summary: 'Listar todos los reportes' })
  @ApiResponse({ status: 200, description: 'Lista de reportes' })
  async listar() {
    return this.reportesService.listar();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener reporte por ID' })
  @ApiResponse({ status: 200, description: 'Reporte encontrado' })
  async obtenerPorId(@Param('id') id: number) {
    return this.reportesService.obtenerPorId(id);
  }

  @Get('oportunidades/por-fecha')
  @ApiOperation({ summary: 'Reporte oportunidades por rango de fechas' })
  @ApiResponse({ status: 200, description: 'Datos de oportunidades por fecha' })
  async porFecha(
    @Query('fecha_inicio') fechaInicio: string,
    @Query('fecha_fin') fechaFin: string,
  ) {
    return this.reportesService.oportunidadesPorFecha(fechaInicio, fechaFin);
  }

  @Get('oportunidades/por-gestor/:idGestor')
  @ApiOperation({ summary: 'Reporte oportunidades por gestor' })
  @ApiResponse({ status: 200, description: 'Datos de oportunidades del gestor' })
  async porGestor(@Param('idGestor') idGestor: number) {
    return this.reportesService.oportunidadesPorGestor(idGestor);
  }

  @Get('oportunidades/ganadas-perdidas')
  @ApiOperation({ summary: 'Reporte oportunidades ganadas vs perdidas' })
  @ApiResponse({ status: 200, description: 'Datos de oportunidades ganadas y perdidas' })
  async ganadas() {
    return this.reportesService.oportunidadesGanadas();
  }
}
