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

  def update_card(card_pid, category, roll) do
    GenServer.call(card_pid, {:update, category, roll})
  end

  def scorecard_name(name) do
    name = name <> "_scorecard"
    String.to_atom(name)
  end

  def categories do
    [&one_pair/1, &two_pairs/1, &three_of_a_kind/1, &four_of_a_kind/1,
    &low_straight/1, &high_straight/1, &full_house/1, &chance/1,
    &yahtzee/1]
  end

  def upper_half(roll, number) do
    list = for n <- roll, n == number, do: n
    Enum.sum(list)
  end

  def one_pair([n, n, _, _, _]), do: n * 2
  def one_pair([_, n, n, _, _]), do: n * 2
  def one_pair([_, _, n, n, _]), do: n * 2
  def one_pair([_, _, _, n, n]), do: n * 2
  def one_pair(_roll), do: 0

  def two_pairs([x, x, y, y, _]) when x != y, do: x * 2 + y * 2
  def two_pairs([x, x, _, y, y]) when x != y, do: x * 2 + y * 2
  def two_pairs([_, x, x, y, y]) when x != y, do: x * 2 + y * 2
  def two_pairs(_roll), do: 0

  def three_of_a_kind([n, n, n, _, _]), do: n * 3
  def three_of_a_kind([_, n, n, n, _]), do: n * 3
  def three_of_a_kind([_, _, n, n, n]), do: n * 3
  def three_of_a_kind(_roll), do: 0

  def four_of_a_kind([n, n, n, n, _]), do: n * 4
  def four_of_a_kind([_, n, n, n, n]), do: n * 4
  def four_of_a_kind(_roll), do: 0

  def low_straight([5, 4, 3, 2, 1]), do: 15
  def low_straight(_roll), do: 0
  def high_straight([6, 5, 4, 3, 2]), do: 20
  def high_straight(_roll), do: 0

  def full_house([x, x, y, y, y]) when x != y, do: x * 2 + y * 3
  def full_house([x, x, x, y, y]) when x != y, do: x * 3 + y * 2
  def full_house(_roll), do: 0

  def chance(roll), do: Enum.sum(roll)
  def yahtzee([n, n, n, n, n]), do: 50
  def yahtzee(_roll), do: 0

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
    roll = YahtzeeTurn.sort(roll)
    new_score = get_score(category, roll)
    scorecard = %{scorecard | category => new_score}
    {:reply, scorecard, scorecard}
  end

  defp get_score(:ones, roll), do: upper_half(roll, 1)
  defp get_score(:twos, roll), do: upper_half(roll, 2)
  defp get_score(:threes, roll), do: upper_half(roll, 3)
  defp get_score(:fours, roll), do: upper_half(roll, 4)
  defp get_score(:fives, roll), do: upper_half(roll, 5)
  defp get_score(:sixes, roll), do: upper_half(roll, 6)
  defp get_score(:one_pair, roll), do: one_pair(roll)
  defp get_score(:two_pairs, roll), do: two_pairs(roll)
  defp get_score(:three_of_a_kind, roll), do: three_of_a_kind(roll)
  defp get_score(:four_of_a_kind, roll), do: four_of_a_kind(roll)
  defp get_score(:low_straight, roll), do: low_straight(roll)
  defp get_score(:high_straight, roll), do: high_straight(roll)
  defp get_score(:full_house, roll), do: full_house(roll)
  defp get_score(:chance, roll), do: chance(roll)
  defp get_score(:yahtzee, roll), do: yahtzee(roll)
end
