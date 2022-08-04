defmodule Yahtzee.Application do
  use Application

  def get_players do
    ["one", "two", "three"]
  end

  @impl true
  def start(_type, _args) do
    children = [
      {YahtzeeScore, []},
      {YahtzeeTurn, []},
      %{
        id: One,
        start: {YahtzeePlayerSupervisor, :start_link, ["one"]}
      },
      %{
        id: Two,
        start: {YahtzeePlayerSupervisor, :start_link, ["two"]}
      },
      %{
        id: Three,
        start: {YahtzeePlayerSupervisor, :start_link, ["three"]}
      }
    ]
    opts = [strategy: :one_for_all, name: Yahtzee.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
