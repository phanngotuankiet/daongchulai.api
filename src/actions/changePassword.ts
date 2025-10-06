import { Request, Response } from 'express';
import * as bcrypt from 'bcryptjs';

export async function changePasswordAction(req: Request, res: Response) {
  try {
    const { user_id, current_password, new_password } = req.body.input;

    // Validate input
    if (!user_id || !new_password) {
      return res.status(400).json({
        message: 'Missing required fields: user_id, new_password'
      });
    }

    // Get user from database
    const userResponse = await fetch(`${process.env.HASURA_URL}/v1/graphql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': process.env.HASURA_ADMIN_SECRET
      },
      body: JSON.stringify({
        query: `
          query GetUser($id: Int!) {
            users_by_pk(id: $id) {
              id
              username
              password
            }
          }
        `,
        variables: { id: user_id }
      })
    });

    const userData = await userResponse.json();
    const user = userData.data.users_by_pk;

    if (!user) {
      return res.status(404).json({
        message: 'User not found'
      });
    }

    // Validate current password (if provided)
    if (current_password) {
      let isCurrentPasswordValid = false;
      
      if (user.password.startsWith('$2a$') || user.password.startsWith('$2b$')) {
        // Password is hashed
        isCurrentPasswordValid = await bcrypt.compare(current_password, user.password);
      } else {
        // Password is plain text (for demo)
        const validPasswords = {
          'admin': 'admin123',
          'user': 'user123'
        };
        const expectedPassword = validPasswords[user.username];
        isCurrentPasswordValid = expectedPassword === current_password;
      }

      if (!isCurrentPasswordValid) {
        return res.status(401).json({
          message: 'Mật khẩu hiện tại bị sai'
        });
      }
    }

    // Hash new password
    const hashedNewPassword = await bcrypt.hash(new_password, 10);

    // Update password in database
    const updateResponse = await fetch(`${process.env.HASURA_URL}/v1/graphql`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-hasura-admin-secret': process.env.HASURA_ADMIN_SECRET
      },
      body: JSON.stringify({
        query: `
          mutation UpdatePassword($id: Int!, $password: String!) {
            update_users_by_pk(pk_columns: { id: $id }, _set: { password: $password }) {
              id
              username
            }
          }
        `,
        variables: { 
          id: user_id, 
          password: hashedNewPassword 
        }
      })
    });

    const updateData = await updateResponse.json();

    if (updateData.errors) {
      return res.status(500).json({
        message: 'Failed to update password',
        errors: updateData.errors
      });
    }

    return res.json({
      message: 'Password changed successfully',
      user: updateData.data.update_users_by_pk
    });

  } catch (error) {
    console.error('Change password error:', error);
    return res.status(500).json({
      message: 'Internal server error'
    });
  }
}
