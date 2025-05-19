defmodule TechnicalScraperApp.Pages.ScrapedPage do
  use Ecto.Schema
  import Ecto.Changeset

  alias TechnicalScraperApp.Accounts.User, as: UserSchema

  @fields ~w(url html title links_count user_id)a
  @required_fields ~w(url html title user_id)a

  @url_regex ~r/^https?:\/\//

  schema "scraped_pages" do
    field :url, :string
    field :html, :string
    field :title, :string
    field :links_count, :integer, default: 0

    belongs_to :user, UserSchema

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(scraped_page, attrs \\ %{}) do
    scraped_page
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_format(:url, @url_regex)
    |> assoc_constraint(:user)
    |> unique_constraint([:url, :user_id])
  end
end
