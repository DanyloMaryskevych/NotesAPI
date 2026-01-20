import { PrismaClient } from '@prisma/client';
import { Signer } from '@aws-sdk/rds-signer';

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

async function generateAuthToken(): Promise<string> {
  const signer = new Signer({
    hostname: process.env.DB_HOST!,
    port: parseInt(process.env.DB_PORT || '5432'),
    username: process.env.DB_USER!,
    region: process.env.AWS_REGION || 'eu-central-1',
  });
  return signer.getAuthToken();
}

function buildDatabaseUrl(token: string): string {
  const host = process.env.DB_HOST;
  const port = process.env.DB_PORT || '5432';
  const user = process.env.DB_USER;
  const database = process.env.DB_NAME;
  return `postgresql://${user}:${encodeURIComponent(token)}@${host}:${port}/${database}?sslmode=require`;
}

let prismaInstance: PrismaClient | undefined;

export async function getPrisma(): Promise<PrismaClient> {
  if (prismaInstance) {
    return prismaInstance;
  }

  const token = await generateAuthToken();
  const databaseUrl = buildDatabaseUrl(token);

  prismaInstance = new PrismaClient({
    datasources: {
      db: {
        url: databaseUrl,
      },
    },
  });

  if (process.env.NODE_ENV !== 'production') {
    globalForPrisma.prisma = prismaInstance;
  }

  return prismaInstance;
}

export const prisma = globalForPrisma.prisma;
