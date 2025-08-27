#!/bin/bash
set -e
# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for the database to be ready
until pg_isready -h db -p 5432; do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

echo "db:5432 - accepting connections"

# Check if the database exists and has tables
COUNT=$(bundle exec rails runner "puts ActiveRecord::Base.connection.tables.count" 2>/dev/null || echo 0)

if [ "$COUNT" -eq "0" ]; then
  echo "Create database if empty...."
  bundle exec rails db:create
fi

# Then exec the container's main process
exec bundle exec "$@"