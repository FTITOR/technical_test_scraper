defmodule TechnicalScraperApp.ScraperTest do
  use TechnicalScraperApp.DataCase, async: true

  import TechnicalScraperApp.AccountsFixtures
  import Mox

  alias TechnicalScraperApp.Scraper
  alias TechnicalScraperApp.Pages.ScrapedPage

  setup :verify_on_exit!

  describe "list/1" do
    test "returns all scraped pages for a user" do
      user = user_fixture()
      other_user = user_fixture(%{email: "other@example.com"})

      Scraper.create(%{url: "https://a.com", user_id: user.id, html: "<html></html>", title: "A", links_count: 1})
      Scraper.create(%{url: "https://b.com", user_id: user.id, html: "<html></html>", title: "B", links_count: 2})
      Scraper.create(%{url: "https://c.com", user_id: other_user.id, html: "", title: "C", links_count: 3})

      result = Scraper.list(user.id)

      assert length(result) == 2
    end
  end

  describe "create/1" do
    test "creates a scraped page with valid data" do
      user = user_fixture()

      attrs = %{
        url: "https://elixir-lang.org",
        html: "<html><title>Elixir</title></html>",
        title: "Elixir",
        links_count: 5,
        user_id: user.id
      }

      assert {:ok, %ScrapedPage{} = page} = Scraper.create(attrs)
      assert page.url == attrs.url
      assert page.title == "Elixir"
      assert page.links_count == 5
    end
  end

  describe "fetch_and_save/2" do
    test "fetches page and stores scraped data" do
      user = user_fixture()

      html = """
      <html>
        <head><title>Test Page</title></head>
        <body>
          <a href="link1"></a>
          <a href="link2"></a>
        </body>
      </html>
      """

      Scraper.MockHTTPClient
      |> expect(:get, fn "https://test.com" ->
        {:ok, %Req.Response{body: html}}
      end)

      assert {:ok, %ScrapedPage{} = page} = Scraper.fetch_and_save("https://test.com", user.id)
      assert page.title == "Test Page"
      assert page.links_count == 2
      assert page.user_id == user.id
    end

    test "returns error when page cannot be fetched" do
      user = user_fixture()

      Scraper.MockHTTPClient
      |> expect(:get, fn "https://bad-url.com" ->
        {:error, :timeout}
      end)

      assert {:error, %Ecto.Changeset{} = changeset} = Scraper.fetch_and_save("https://bad-url.com", user.id)
      assert "could not fetch URL" in errors_on(changeset).url
    end
  end
end
