defmodule YahtzeeTurn do
  use GenStateMachine

  # API
  def start_link(_) do
    GenStateMachine.start_link(__MODULE__, {:three_rolls, []}, name: __MODULE__)
  end

  def roll(keep \\ []) do
    dice = 1..6
    number_of_dice = 5 - Enum.count(keep)
    func = fn -> Enum.random(dice) end
    roll = Stream.repeatedly(func) |> Enum.take(number_of_dice)
    keep ++ roll
  end

  def sort(roll) do
    Enum.sort(roll, :desc)
  end

  def check(roll) do
    roll = sort(roll)
    upper = for n <- 1..6, do: YahtzeeScorecard.upper_half(roll, n)
    c = YahtzeeScorecard.categories()
    lower = Enum.map(c, fn f -> f.(roll) end)
    upper ++ lower
  end

  def update_roll(pid, keep) do
    GenStateMachine.call(pid, {:roll, keep}) #TODO use __MODULE__ instead of pid
  end

  def update_roll(pid) do #TODO consider removing and using default parameter [] in the function above.
    GenStateMachine.call(pid, :roll)
  end

  def end_turn(pid) do
    GenStateMachine.cast(pid, :end_turn)
  end

  def reset(pid) do
    GenStateMachine.cast(pid, :reset)
  end

  def get_state(pid) do
    GenStateMachine.call(pid, :get_state)
  end

  def get_roll(pid) do
    GenStateMachine.call(pid, :get_roll)
  end

  # Callbacks
  def handle_event({:call, from}, {:roll, keep}, :three_rolls, data) do #TODO rename data -> dice_kept
    data = data ++ keep
    {:next_state, :two_rolls, data, [{:reply, from, data}]}
  end

  def handle_event({:call, from}, {:roll, keep}, :two_rolls, data) do
    data = data ++ keep
    {:next_state, :one_roll, data, [{:reply, from, data}]}
  end

  def handle_event({:call, from}, {:roll, _keep}, :one_roll, data) do
     {:next_state, :no_rolls, data, [{:reply, from, []}]}
  end

  def handle_event(:cast, :end_turn, :three_rolls, _data) do
    {:next_state, :no_rolls, []}
  end

  def handle_event(:cast, :end_turn, :two_rolls, _data) do
    {:next_state, :no_rolls, []}
  end

  def handle_event(:cast, :end_turn, :one_roll, _data) do
    {:next_state, :no_rolls, []}
  end

  def handle_event(:cast, :reset, :two_rolls, _data) do
    {:next_state, :three_rolls, []}
  end

  def handle_event(:cast, :reset, :one_roll, _data) do
    {:next_state, :three_rolls, []}
  end

  def handle_event(:cast, :reset, :no_rolls, _data) do
    {:next_state, :three_rolls, []}
  end

  def handle_event({:call, from}, :get_roll, state, data) do
    {:next_state, state, data, [{:reply, from, data}]}
  end

  def handle_event({:call, from}, :get_state, state, data) do
    {:next_state, state, data, [{:reply, from, state}]}
  end
end
