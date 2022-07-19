defmodule YahtzeePlayerSupervisor do
  use Supervisor
  require Logger

  @impl true
  def init(arg) do
    Logger.debug("YPS 7: Test: #{inspect(arg)}")
    children = [
      {YahtzeePlayer, arg},
      {YahtzeeScorecard, arg}
    ]

    opts = [strategy: :one_for_all, name: Yahtzee.Supervisor]
    Supervisor.start_link(children, opts)
  end
end