import type { CodegenConfig } from '@graphql-codegen/cli';
import * as dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const hasuraUrl = process.env.HASURA_URL;
const hasuraAdminSecret = process.env.HASURA_ADMIN_SECRET;

if (!hasuraUrl || !hasuraAdminSecret) {
  throw new Error('Missing required environment variables for codegen');
}

const config: CodegenConfig = {
  schema: [
    {
      [hasuraUrl]: {
        headers: {
          'x-hasura-admin-secret': hasuraAdminSecret,
        },
      },
    },
  ],
  documents: ['src/graphql/**/*.graphql'],
  generates: {
    './src/generated/graphql.ts': {
      plugins: [
        'typescript',
        'typescript-operations',
        'typescript-graphql-request',
      ],
      config: {
        skipTypename: false,
        withHooks: true,
        withHOC: false,
        withComponent: false,
      },
    },
  },
};

export default config;
