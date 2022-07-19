defmodule Yahtzee do
  def roll(number_of_dice \\ 5) do
    dice = 1..6
    func = fn -> Enum.random(dice) end
    Stream.repeatedly(func) |> Enum.take(number_of_dice)
  end

  def sort(roll) do
    Enum.sort(roll, :desc)
  end

  def categories do
    [&one_pair/1, &two_pairs/1, &three_of_a_kind/1, &four_of_a_kind/1,
    &low_straight/1, &high_straight/1, &full_house/1, &chance/1,
    &yahtzee/1]
  end

  def check(roll) do
    roll = sort(roll)
    upper = for n <- 1..6, do: upper_half(roll, n)
    c = categories()
    lower = Enum.map(c, fn f -> f.(roll) end)
    upper ++ lower
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
end
