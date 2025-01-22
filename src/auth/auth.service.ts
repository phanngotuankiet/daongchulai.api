import { Injectable } from '@nestjs/common';
import { JwtService } from './jwt.service';

@Injectable()
export class AuthService {
  constructor(private jwtService: JwtService) {}

  async login(user: any) {
    // After validating user credentials
    const token = await this.jwtService.generateToken(
      user.id.toString(),
      ['admin'], // or ["user", "admin"] based on user roles
    );

    return {
      access_token: token,
      user: {
        id: user.id,
        email: user.email,
        // other user fields...
      },
    };
  }
}
