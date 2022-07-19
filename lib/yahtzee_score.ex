defmodule YahtzeeScore do
  use GenServer

  ## API
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def calculate(roll) do
    GenServer.call(__MODULE__, {:roll, roll})
  end

  ## Callbacks
  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call({:roll, roll}, _from, state) do
    scores = Yahtzee.check(roll)
    {:reply, scores, state}
  end
end