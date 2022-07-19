defmodule YahtzeeTest do
  use ExUnit.Case
  doctest Yahtzee

  test "sort is correct" do
    roll = [6, 3, 1, 3, 2]
    assert Yahtzee.sort(roll) == [6, 3, 3, 2, 1]
  end

  test "one pair roll is correct" do
    roll = [1, 2, 4, 3, 3]
    assert Yahtzee.check(roll) == [1, 2, 6, 4, 0, 0, 6, 0, 0, 0, 0, 0, 0, 13, 0]
  end

  test "two pairs roll is correct" do
    roll = [4, 2, 4, 5, 2]
    assert Yahtzee.check(roll) == [0, 4, 0, 8, 5, 0, 8, 12, 0, 0, 0, 0, 0, 17, 0]
  end

  test "three of a kind roll is correct" do
    roll = [3, 3, 1, 6, 3]
    assert Yahtzee.check(roll) == [1, 0, 9, 0, 0, 6, 6, 0, 9, 0, 0, 0, 0, 16, 0]
  end

  test "four of a kind roll is correct" do
    roll = [4, 2, 4, 4, 4]
    assert Yahtzee.check(roll) == [0, 2, 0, 16, 0, 0, 8, 0, 12, 16, 0, 0, 0, 18, 0]
  end

  test "low straight roll is correct" do
    roll = [4, 5, 2, 3, 1]
    assert Yahtzee.check(roll) == [1, 2, 3, 4, 5, 0, 0, 0, 0, 0, 15, 0, 0, 15, 0]
  end

  test "high straight roll is correct" do
    roll = [6, 2, 5, 3, 4]
    assert Yahtzee.check(roll) == [0, 2, 3, 4, 5, 6, 0, 0, 0, 0, 0, 20, 0, 20, 0]
  end

  test "full house roll is correct" do
    roll = [5, 4, 5, 4, 5]
    assert Yahtzee.check(roll) == [0, 0, 0, 8, 15, 0, 10, 18, 15, 0, 0, 0, 23, 23, 0]
  end

  test "chance roll is correct" do
    roll = [6, 1, 2, 5, 3]
    assert Yahtzee.check(roll) == [1, 2, 3, 0, 5, 6, 0, 0, 0, 0, 0, 0, 0, 17, 0]
  end

  test "yahtzee roll is correct" do
    roll = [6, 6, 6, 6, 6]
    assert Yahtzee.check(roll) == [0, 0, 0, 0, 0, 30, 12, 0, 18, 24, 0, 0, 0, 30, 50]
  end
end