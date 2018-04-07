defmodule AmazonHistory.CLI do
  @moduledoc """
  Handle the command-line parsing for the amazon_history tool
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(username: username, password: password) do
    IO.puts("Will continue with username: #{username}, password: #{password}")
  end

  def process(_) do
    IO.puts("Usage: --username <username> --password <password>")
  end

  @doc """
  Options:
  -u/--username: Amazon username
  -p/--password: Amazon password
  """
  def parse_args(argv) do
    OptionParser.parse(
      argv,
      switches: [
        help: :boolean,
        username: :string,
        password: :string
      ],
      aliases: [
        h: :help,
        u: :username,
        p: :password
      ]
    )
    |> elem(0)
    |> args_to_internal_representation
  end

  defp args_to_internal_representation(username: username, password: password) do
    [username: username, password: password]
  end

  defp args_to_internal_representation(_) do
    :help
  end
end
