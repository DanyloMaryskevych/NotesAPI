#!/bin/sh
set -e

echo "Running database migrations..."
node src/db/migrate.mjs

echo "Starting application..."
exec node server.js
