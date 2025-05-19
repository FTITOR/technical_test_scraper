defmodule TechnicalScraperApp.Scraper.HTTPClient do
  @callback get(String.t()) :: {:ok, map()} | {:error, term()}
end
