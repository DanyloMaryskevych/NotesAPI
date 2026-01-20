#!/bin/sh
set -e

# Generate IAM auth token for RDS
TOKEN=$(node -e "
const { Signer } = require('@aws-sdk/rds-signer');
const signer = new Signer({
  hostname: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USER,
  region: process.env.AWS_REGION
});
signer.getAuthToken().then(token => console.log(token));
")

# Set DATABASE_URL for Prisma CLI
export DATABASE_URL="postgresql://${DB_USER}:$(echo $TOKEN | sed 's/+/%2B/g; s/=/%3D/g; s/&/%26/g')@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=require"

# Run migrations
echo "Running database migrations..."
npx prisma db push --skip-generate

# Start the app
echo "Starting application..."
exec node server.js
