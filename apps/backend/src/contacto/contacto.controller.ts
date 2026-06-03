import { Controller, Get, Post, Put, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { ContactoService } from './contacto.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@ApiTags('Contactos')
@ApiBearerAuth()
@Controller('api/contactos')
@UseGuards(JwtAuthGuard)
export class ContactoController {
  constructor(private contactoService: ContactoService) {}

  @Get()
  @ApiOperation({ summary: 'Listar todos los contactos' })
  @ApiResponse({ status: 200, description: 'Lista de contactos' })
  async listar() {
    return this.contactoService.listar();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener contacto por ID' })
  @ApiResponse({ status: 200, description: 'Contacto encontrado' })
  async obtenerPorId(@Param('id') id: number) {
    return this.contactoService.obtenerPorId(id);
  }

  @Post()
  @ApiOperation({ summary: 'Crear nuevo contacto' })
  @ApiResponse({ status: 201, description: 'Contacto creado exitosamente' })
  async crear(@Body() contactoData: any) {
    return this.contactoService.insertar(contactoData);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Actualizar contacto' })
  @ApiResponse({ status: 200, description: 'Contacto actualizado exitosamente' })
  async actualizar(@Param('id') id: number, @Body() contactoData: any) {
    return this.contactoService.actualizar(id, contactoData);
  }

  @Get('cliente/:idCliente')
  @ApiOperation({ summary: 'Obtener contactos de un cliente' })
  @ApiResponse({ status: 200, description: 'Lista de contactos' })
  async porCliente(@Param('idCliente') idCliente: number) {
    return this.contactoService.consultarPorCliente(idCliente);
  }
}
