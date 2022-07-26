defmodule YahtzeePlayerSupervisor do
  use Supervisor
  require Logger

  ## API
  def start_link(name) do
    name_atom = convert_to_atom(name)
    Supervisor.start_link(__MODULE__, name, name: name_atom)
  end

  def convert_to_atom(str) do
    String.to_atom(str <> "_sup")
  end

  ## Callbacks
  @impl true
  def init(arg) do
    children = [
      {YahtzeePlayer, arg},
      {YahtzeeScorecard, arg}
    ]
    Supervisor.init(children, strategy: :rest_for_one)
  end
end
