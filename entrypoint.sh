# #!/bin/bash
# # docker entrypoint script.

# # assign a default for the database_user
# DB_USER=${DATABASE_USER:-postgres}

# # wait until Postgres is ready
# while ! pg_isready -q -h $DATABASE_HOST -p 5432 -U $DB_USER
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

# # bin="/app/bin/financial_transactions"

# # # start the elixir application
# # echo "$(date) - running migrations"
# # eval "$bin eval \"FinancialTransactions.Release.migrate\"" 

# # echo "$(date) - running application"

# # exec "$bin" "start"



# entrypoint.sh

#!/bin/bash
# Docker entrypoint script.

DB_USER=${DATABASE_USER:-postgres}

echo $DB_HOST
echo $DB_USER

# Wait until Postgres is ready
while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

# npm install -g brunch
# cd assets && npm install && node node_modules/brunch/bin/brunch build

# exec mix ecto.migrate
# exec mix test

#Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $DATABASE_DB"` ]]; then
  echo "Database $DATABASE_DB does not exist. Creating..."
  echo "running migrations"
  mix ecto.migrate
  echo "make seeds"
  mix run priv/repo/seeds.exs
  echo "Database $DATABASE_DB created."
fi

exec mix phx.server
