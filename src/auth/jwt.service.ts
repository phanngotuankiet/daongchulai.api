import { Injectable } from '@nestjs/common';
import { JwtService as NestJwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtService {
  constructor(
    private jwtService: NestJwtService,
    private configService: ConfigService,
  ) {}

  async generateToken(userId: string, roles: string[]) {
    const payload = {
      sub: userId,
      'https://hasura.io/jwt/claims': {
        'x-hasura-allowed-roles': roles,
        'x-hasura-default-role': 'user',
        'x-hasura-user-id': userId,
      },
      iat: Math.floor(Date.now() / 1000),
      aud: 'daongchulai-api',
      iss: 'daongchulai-auth',
    };

    return this.jwtService.sign(payload);
  }

  async verifyToken(token: string) {
    return this.jwtService.verify(token);
  }
}
