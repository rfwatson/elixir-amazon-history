defmodule AmazonHistory.CLI do
  @moduledoc """
  Handle the command-line parsing for the amazon_history tool
  """

  require Logger

  def run(argv) do
    argv
    |> parse_args
    |> scrape
    |> CSV.encode
    |> Enum.each(&IO.write/1)
  end

  def scrape(email: email, password: password, start_year: start_year) do
    Logger.debug("Will scrape with email: #{email}, password: ****")
    AmazonHistory.Scraper.fetch(email, password, start_year)
  end

  def scrape(_) do
    IO.puts(:stderr, "Usage: --email <email> --password <password> --start-year <start year>")
  end

  @doc """
  Options:
  -e/--email: Amazon email
  -p/--password: Amazon password
  """
  def parse_args(argv) do
    OptionParser.parse(
      argv,
      switches: [
        help: :boolean,
        email: :string,
        password: :string,
        start_year: :integer,
      ],
      aliases: [
        h: :help,
        e: :email,
        p: :password,
        y: :start_year,
      ]
    )
    |> elem(0)
    |> args_to_internal_representation
  end

  defp args_to_internal_representation(email: email, password: password, start_year: start_year) do
    [email: email, password: password, start_year: start_year]
  end

  defp args_to_internal_representation(email: email, password: password) do
    [email: email, password: password, start_year: 2000]
  end

  defp args_to_internal_representation(_) do
    :help
  end
end
