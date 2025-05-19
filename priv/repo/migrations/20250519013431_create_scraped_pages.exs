defmodule TechnicalScraperApp.Repo.Migrations.CreateScrapedPages do
  use Ecto.Migration

  def change do
    create table(:scraped_pages) do
      add :url, :string
      add :html, :text

      timestamps(type: :utc_datetime)
    end
  end
end
