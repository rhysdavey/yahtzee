defmodule YahtzeePlayer do
  use GenServer
  require Logger

  ## API
  def start_link(name) do
    Logger.debug("YP 7: Test: #{inspect(name)}")
    reg_name = player_name(name)
    scorecard_name = YahtzeeScorecard.scorecard_name(name)
    GenServer.start_link(__MODULE__, scorecard_name, name: reg_name)
  end

  def get_scorecard(name) do
    GenServer.call(name, :get_scorecard)
  end

  def player_name(name) do
    name = name <> "_player"
    String.to_atom(name)
  end


  ## Callbacks
  @impl true
  def init(scorecard_name) do
    Logger.debug("YP 26: Test: #{inspect(scorecard_name)}")
    {:ok, scorecard_name}
  end

  @impl true
  def handle_call(:get_scorecard, _from, scorecard_name) do
    scorecard = YahtzeeScorecard.get_card(scorecard_name)
    {:reply, scorecard, scorecard_name}
  end
end
