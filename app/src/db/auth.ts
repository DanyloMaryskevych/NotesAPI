import { Signer } from '@aws-sdk/rds-signer';

export const isLocal = process.env.NODE_ENV === 'development';

export const signer = new Signer({
  region: process.env.AWS_REGION || 'eu-north-1',
  hostname: process.env.DB_HOST!,
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USER!,
});
