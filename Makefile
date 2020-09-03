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