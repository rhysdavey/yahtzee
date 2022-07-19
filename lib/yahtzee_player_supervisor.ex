defmodule YahtzeePlayerSupervisor do
  use Supervisor
  require Logger

  ## API
  def start_link(name) do
    name_atom = convert_to_atom(name)
    GenServer.start_link(__MODULE__, name, name: name_atom)
  end

  def convert_to_atom(str) do
    String.to_atom(str <> "_sup")
  end

  ## Callbacks 
  @impl true
  def init(name) do
    Logger.debug("YPS 18: Test: #{inspect(name)}")
    children = [
      {YahtzeePlayer, name},
      {YahtzeeScorecard, name}
    ]
    Logger.debug("YPS 23: Test: #{inspect(children)}")
    Supervisor.init(children, strategy: :one_for_one)
  end
end