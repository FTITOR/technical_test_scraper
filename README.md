# TechnicalScraperApp
is an application built with Elixir and the Phoenix Framework to scrape web pages and store the extracted data per user.

## Quick Start

To run the system locally, follow these steps:

Set up the environment
  * Run the following command from the Makefile:
`make setup`
This command installs Elixir dependencies and runs the necessary database migrations. (Optional if already set up)
  * Install frontend dependencies
`cd assets && npm install && cd ..`
  * Start the server
`make run`
This command runs the database migrations and starts the Phoenix server.
  * Run unit tests (optional)
`make run_test`
Minimum Requirements

Elixir: 1.16.1
Erlang: 26.2
Node.js: 14.18.2
OpenSSL: 3.x or higher
Note: OpenSSL version 3 or higher is required because Phoenix uses it for user authentication.

Accessing the App

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
