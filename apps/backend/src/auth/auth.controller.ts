import { Controller, Post, Body, UseGuards, Request, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './jwt-auth.guard';

@ApiTags('Auth')
@Controller('api/auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  @ApiOperation({ summary: 'Login usuario' })
  @ApiResponse({ status: 200, description: 'Login exitoso, retorna access_token y refresh_token' })
  @ApiResponse({ status: 401, description: 'Credenciales inválidas' })
  async login(@Body() data: { correo: string; password: string }) {
    return this.authService.login(data.correo, data.password);
  }

  @UseGuards(JwtAuthGuard)
  @Post('refresh')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Renovar access token' })
  @ApiResponse({ status: 200, description: 'Token renovado exitosamente' })
  async refresh(@Request() req) {
    return this.authService.refresh(req.user);
  }

  @UseGuards(JwtAuthGuard)
  @Get('me')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener datos usuario actual' })
  @ApiResponse({ status: 200, description: 'Datos del usuario logueado' })
  getProfile(@Request() req) {
    return req.user;
  }
}
