defmodule TechnicalScraperApp.Scraper do
  @moduledoc """
  Provides functionality to fetch, parse, and store scraped web pages
  associated with users.
  """

  import Ecto.Query, warn: false
  alias TechnicalScraperApp.Repo

  alias TechnicalScraperApp.Pages.ScrapedPage

  @doc """
  Returns a list of scraped pages for the given user.

  ## Parameters

    - `user_id`: The ID of the user whose scraped pages are being retrieved.

  ## Examples

      iex> TechnicalScraperApp.Scraper.list(1)
      [%ScrapedPage{}, ...]

  """
  @spec list(integer()) :: list()
  def list(user_id) do
    ScrapedPage
    |> where([sp], sp.user_id == ^user_id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Creates a new scraped page record with the given attributes.

  ## Parameters

    - `attrs`: A map of attributes to apply to the new record.

  ## Examples

      iex> TechnicalScraperApp.Scraper.create(%{url: "https://example.com", ...})
      {:ok, %ScrapedPage{}}

  """
  @spec create(map()) :: {:ok, ScrapedPage.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %ScrapedPage{}
    |> ScrapedPage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Fetches a web page from the given URL, extracts metadata, and stores the result
  in the database.

  ## Parameters

    - `url`: The URL of the page to fetch.
    - `user_id`: The ID of the user who requested the page scraping.

  ## Examples

      iex> TechnicalScraperApp.Scraper.fetch_and_save("https://elixir-lang.org", 1)
      {:ok, %ScrapedPage{}}

  """
  @spec fetch_and_save(String.t(), integer()) :: tuple()
  def fetch_and_save(url, user_id) do
    http_client = Application.get_env(:technical_scraper_app, :http_client, Req)

    url
    |> http_client.get()
    |> validate_page_data(url, user_id)
  end

  defp validate_page_data({:ok, %Req.Response{body: html}}, url, user_id) do
    {:ok, document} = Floki.parse_document(html)

    title =
      document
      |> Floki.find("title")
      |> Floki.text()
      |> String.trim()

    links_count =
      document
      |> Floki.find("a")
      |> length()

    create(%{
      url: url,
      html: html,
      title: title,
      links_count: links_count,
      user_id: user_id
    })
  end

  defp validate_page_data({:error, _}, _, _) do
    %ScrapedPage{}
    |> ScrapedPage.changeset(%{})
    |> Ecto.Changeset.add_error(:url, "could not fetch URL")
    |> then(&{:error, &1})
  end
end
