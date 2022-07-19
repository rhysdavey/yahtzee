defmodule Yahtzee.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Newapp.Worker.start_link(arg)
      # {Newapp.Worker, arg}
      {YahtzeeScore, []},
      %{
        id: One,
        start: {YahtzeePlayerSupervisor, :start_link, [["one"]]}
      },
      %{
        id: Two,
        start: {YahtzeePlayerSupervisor, :start_link, [["two"]]}
      },
      %{
        id: Three,
        start: {YahtzeePlayerSupervisor, :start_link, [["three"]]}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Yahtzee.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

#
#        app
#         |
#        sup
#         |
#   /------|--- ..... --\----------|
#  sup    sup           sup       ysc 
#   |
# |----|
# p1   sc1 
#