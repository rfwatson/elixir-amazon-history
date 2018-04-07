defmodule CliTest do
  use ExUnit.Case

  describe "parse_args/1" do
    import AmazonHistory.CLI, only: [parse_args: 1]

    test ":help returned by passing -h and --help options" do
      assert parse_args(["-h"]) == :help
      assert parse_args(["--help"]) == :help
    end

    test ":help returned by passing only a email" do
      assert parse_args(["-e", "rob@netflux.io"]) == :help
      assert parse_args(["--email", "rob@netflux.io"]) == :help
    end

    test ":help returned by passing only a password" do
      assert parse_args(["-p", "hackme"]) == :help
      assert parse_args(["--password", "hackme"]) == :help
    end

    test "arguments returned by passing valid parameters" do
      assert parse_args(["-e", "rob@netflux.io", "-p", "hackme"]) == [email: "rob@netflux.io", password: "hackme"]

      assert parse_args(["--email", "rob@netflux.io", "--password", "hackme"]) == [
               email: "rob@netflux.io",
               password: "hackme"
             ]
    end
  end
end
