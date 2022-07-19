defmodule YahtzeeScorecard do
  use GenServer

  defstruct [:ones, :twos, :threes, :fours, :fives, :sixes, :bonus,
    :one_pair, :two_pairs, :three_of_a_kind, :four_of_a_kind, :low_straight,
    :high_straight, :full_house, :chance, :yahtzee, :total]

  ## API
  def start_link(name) do
    scorecard = %YahtzeeScorecard{}
    reg_scorecard = scorecard_name(name)
    GenServer.start_link(__MODULE__, scorecard, name: reg_scorecard)
  end

  def get_card(card_name) do
    GenServer.call(card_name, {:score})
  end

  def update_card(card_pid, category, roll) do #TODO update card
    GenServer.call(card_pid, {:update, category, roll})
  end

  def scorecard_name(name) do
    name = name <> "_scorecard"
    String.to_atom(name)
  end


  ## Callbacks
  @impl true
  def init(scorecard) do
    {:ok, scorecard}
  end

  @impl true
  def handle_call({:score}, _from, scorecard) do
    {:reply, scorecard, scorecard}
  end

  @impl true
  def handle_call({:update, category, roll}, _from, scorecard) do
    roll = Yahtzee.sort(roll)
    new_score = get_score(category, roll)
    scorecard = %{scorecard | category => new_score}
    {:reply, scorecard, scorecard}
  end

  defp get_score(:ones, roll), do: Yahtzee.upper_half(roll, 1)
  defp get_score(:twos, roll), do: Yahtzee.upper_half(roll, 2)
  defp get_score(:threes, roll), do: Yahtzee.upper_half(roll, 3)
  defp get_score(:fours, roll), do: Yahtzee.upper_half(roll, 4)
  defp get_score(:fives, roll), do: Yahtzee.upper_half(roll, 5)
  defp get_score(:sixes, roll), do: Yahtzee.upper_half(roll, 6)
  defp get_score(:one_pair, roll), do: Yahtzee.one_pair(roll)
  defp get_score(:two_pairs, roll), do: Yahtzee.two_pairs(roll)
  defp get_score(:three_of_a_kind, roll), do: Yahtzee.three_of_a_kind(roll)
  defp get_score(:four_of_a_kind, roll), do: Yahtzee.four_of_a_kind(roll)
  defp get_score(:low_straight, roll), do: Yahtzee.low_straight(roll)
  defp get_score(:high_straight, roll), do: Yahtzee.high_straight(roll)
  defp get_score(:full_house, roll), do: Yahtzee.full_house(roll)
  defp get_score(:chance, roll), do: Yahtzee.chance(roll)
  defp get_score(:yahtzee, roll), do: Yahtzee.yahtzee(roll)
end
