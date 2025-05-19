defmodule TechnicalScraperApp.Repo do
  use Ecto.Repo,
    otp_app: :technical_scraper_app,
    adapter: Ecto.Adapters.Postgres
end
