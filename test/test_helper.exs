ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TechnicalScraperApp.Repo, :manual)

Mox.defmock(TechnicalScraperApp.Scraper.MockHTTPClient, for: TechnicalScraperApp.Scraper.HTTPClient)
Application.put_env(:technical_scraper_app, :http_client, TechnicalScraperApp.Scraper.MockHTTPClient)
