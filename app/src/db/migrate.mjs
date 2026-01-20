import path from 'path';
import { fileURLToPath } from 'url';
import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import pg from 'pg';
import { Signer } from '@aws-sdk/rds-signer';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const isLocal = process.env.NODE_ENV === 'development';

const signer = new Signer({
  region: process.env.AWS_REGION || 'eu-north-1',
  hostname: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USER,
});

async function main() {
  console.log('Starting database migration...');

  const password = isLocal
    ? process.env.DB_PASSWORD
    : await signer.getAuthToken();

  const client = new pg.Client({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT || '5432'),
    user: process.env.DB_USER,
    database: process.env.DB_NAME,
    password,
    ssl: isLocal ? false : { rejectUnauthorized: false },
  });

  await client.connect();

  const db = drizzle(client);

  await migrate(db, {
    migrationsFolder: path.join(__dirname, 'migrations'),
  });

  await client.end();

  console.log('Migration completed successfully!');
}

main().catch((err) => {
  console.error('Migration failed:', err);
  process.exit(1);
});
