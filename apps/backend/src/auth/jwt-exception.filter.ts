import { ExceptionFilter, Catch, ArgumentsHost, HttpStatus, UnauthorizedException } from '@nestjs/common';
import { Response } from 'express';

@Catch(UnauthorizedException)
export class JwtExceptionFilter implements ExceptionFilter {
  catch(exception: UnauthorizedException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const message = exception.getResponse() as any;

    if (message.message?.includes('expired') || exception.message?.includes('expired')) {
      response.status(HttpStatus.UNAUTHORIZED).json({
        statusCode: 401,
        message: 'Token has expired',
        code: 'TOKEN_EXPIRED',
      });
    } else {
      response.status(HttpStatus.UNAUTHORIZED).json({
        statusCode: 401,
        message: 'Unauthorized',
        code: 'UNAUTHORIZED',
      });
    }
  }
}
