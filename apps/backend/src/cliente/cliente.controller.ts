import { Controller, Get, Post, Put, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { ClienteService } from './cliente.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Clientes')
@ApiBearerAuth()
@Controller('api/clientes')
@UseGuards(JwtAuthGuard)
export class ClienteController {
  constructor(private clienteService: ClienteService) {}

  @Post()
  @ApiOperation({ summary: 'Crear nuevo cliente' })
  @ApiResponse({ status: 201, description: 'Cliente creado exitosamente' })
  async crear(@Body() clienteData: any) {
    return this.clienteService.insertar(clienteData);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar cliente' })
  @ApiResponse({ status: 200, description: 'Cliente actualizado exitosamente' })
  async actualizar(@Param('id') id: number, @Body() clienteData: any) {
    return this.clienteService.actualizar(id, clienteData);
  }

  @Get()
  @ApiOperation({ summary: 'Listar clientes con filtros' })
  @ApiResponse({ status: 200, description: 'Lista de clientes' })
  async consultar(
    @Query('id') id?: number,
    @Query('codigo') codigo?: string,
    @Query('nombre') nombre?: string,
    @Query('tipo') tipo?: number,
    @Query('estado') estado?: number,
  ) {
    return this.clienteService.consultar({ id, codigo, nombre, tipo, estado });
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener cliente por ID' })
  @ApiResponse({ status: 200, description: 'Datos del cliente' })
  @ApiResponse({ status: 404, description: 'Cliente no encontrado' })
  async obtenerPorId(@Param('id') id: number) {
    const result = await this.clienteService.consultar({ id });
    return result.length > 0 ? result[0] : null;
  }
}
