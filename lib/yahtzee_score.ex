defmodule YahtzeeScore do
  use GenServer
  require Logger

  ## API
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def calculate(keep \\ []) do
    GenServer.call(__MODULE__, {:roll, keep})
  end

  ## Callbacks
  @impl true
  def init(_) do
    {:ok, []}
  end

  @impl true
  def handle_call({:roll, keep}, _from, state) do
    roll = YahtzeeTurn.roll(keep)
    scores = YahtzeeTurn.check(roll)
    {:reply, scores, state}
  end
end