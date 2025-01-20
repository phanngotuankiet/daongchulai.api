"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv = require("dotenv");
dotenv.config();
const hasuraUrl = process.env.HASURA_URL;
const hasuraAdminSecret = process.env.HASURA_ADMIN_SECRET;
if (!hasuraUrl || !hasuraAdminSecret) {
    throw new Error('Missing required environment variables for codegen');
}
const config = {
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
exports.default = config;
//# sourceMappingURL=codegen.js.map