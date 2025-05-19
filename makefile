APP_NAME=technical_scraper_app

.PHONY: setup deps migrate server reset_db

setup: deps migrate

deps:
	mix deps.get

migrate:
	mix ecto.setup

run:
	mix phx.server

reset_db:
	mix ecto.drop
	mix ecto.create
	mix ecto.migrate

run_test:
	MIX_ENV=test mix ecto.create --quiet
	MIX_ENV=test mix ecto.migrate --quiet
	mix test