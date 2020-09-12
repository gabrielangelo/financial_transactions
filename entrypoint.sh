#!/bin/bash
# docker entrypoint script.

# assign a default for the database_user
DB_USER=${DATABASE_USER:-postgres}

# wait until Postgres is ready
while ! pg_isready -q -h $DATABASE_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin="/app/bin/financial_transactions"
# start the elixir application
echo "$(date) - running migrations"
eval "$bin eval \"FinancialTransactions.Release.migrate\"" 

echo "$(date) - running application"

exec "$bin" "start"