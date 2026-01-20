import { drizzle } from 'drizzle-orm/node-postgres';
import { isLocal, signer } from './auth';
import * as schema from './schema';

export const db = drizzle({
  connection: {
    host: process.env.DB_HOST!,
    port: parseInt(process.env.DB_PORT || '5432'),
    user: process.env.DB_USER!,
    database: process.env.DB_NAME!,
    password: isLocal ? process.env.DB_PASSWORD : async () => signer.getAuthToken(),
    ssl: isLocal ? false : { rejectUnauthorized: false },
  },
  schema,
});

export { schema };
