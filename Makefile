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

setup:
	@mix ecto.setup
	@mix ecto.migrate
	@mix test
	@mix phx.server

release: 
	@mix phx.digest && MIX_ENV=prod mix release
	@_build/prod/rel/financial_transactions/bin/financial_transactions eval FinancialTransactions.Release.migrate
	@_build/prod/rel/financial_transactions/bin/financial_transactions start

build_container:
	@chmod +x entrypoint.sh
	@docker-compose build
	@docker-compose up

init:
	@docker-compose -f docker-compose.yaml up