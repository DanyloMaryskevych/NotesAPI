#!/bin/sh
set -e

# Generate IAM auth token for RDS using AWS CLI
TOKEN=$(aws rds generate-db-auth-token \
  --hostname "$DB_HOST" \
  --port "${DB_PORT:-5432}" \
  --username "$DB_USER" \
  --region "$AWS_REGION")

# Set DATABASE_URL for Prisma CLI
export DATABASE_URL="postgresql://${DB_USER}:$(echo $TOKEN | sed 's/+/%2B/g; s/=/%3D/g; s/&/%26/g')@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=require"

# Run migrations
echo "Running database migrations..."
npx prisma db push --skip-generate

# Start the app
echo "Starting application..."
exec node server.js
