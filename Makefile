shell:
	@iex -S mix phx.server

migrate:
	@mix ecto.migrate

reset_db:
	@mix ecto.reset

deps:
	@mix deps.get

run:
	@mix phx.server 

api_routes:
	@mix phx.routes | grep api/v1

coveralls: 
	@mix coveralls

release: 
	@mix phx.digest && MIX_ENV=prod mix release
	@_build/prod/rel/financial_transactions/bin/financial_transactions eval FinancialTransactions.Release.migrate
	@_build/prod/rel/financial_transactions/bin/financial_transactions start

build_container:
	@docker build -t financial-transactions-app .
	@chmod +x entrypoint.sh
	@docker run --rm   -e DATABASE_HOST=localhost -e SECRET_KEY_BASE=1 -e DATABASE_URL=ecto://postgres:postgres@localhost/financial_transactions_dev \
	 --net=host financial-transactions-app

init:
	@docker-compose -f docker-compose.yaml up