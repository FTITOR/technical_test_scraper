defmodule TechnicalScraperAppWeb.ScrapedPageLive.Index do
  use TechnicalScraperAppWeb, :live_view

  alias TechnicalScraperApp.Scraper
  alias TechnicalScraperApp.Pages.ScrapedPage

  def mount(_, _, socket) do
    current_user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(:url, "")
     |> assign(:scraped_pages, Scraper.list(current_user.id))
     |> assign(:changeset, ScrapedPage.changeset(%ScrapedPage{}))}
  end

  def handle_event("validate", %{"scraped_page" => %{"url" => url}}, socket) do
    changeset =
      %ScrapedPage{}
      |> ScrapedPage.changeset(%{"url" => url})
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"scraped_page" => %{"url" => url}}, socket) do
    user = socket.assigns.current_user

    url
    |> Scraper.fetch_and_save(user.id)
    |> validate_response(socket, user)
  end

  defp validate_response({:ok, _}, socket, user) do
    pages = Scraper.list(user.id)

    {:noreply,
     assign(socket, scraped_pages: pages, changeset: ScrapedPage.changeset(%ScrapedPage{}))}
  end

  defp validate_response({:error, changeset}, socket, _),
    do: {:noreply, assign(socket, changeset: changeset)}
end
