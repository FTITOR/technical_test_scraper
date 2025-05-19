defmodule TechnicalScraperApp.Repo.Migrations.AddFieldsToScrapedPages do
  use Ecto.Migration

  def change do
    alter table(:scraped_pages) do
      add :title, :string
      add :links_count, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
  end
end
