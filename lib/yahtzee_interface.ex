defmodule YahtzeeInterface do
  @dice_count 5

  def start_game do
    IO.puts("Welcome to Yahtzee!")
    players = Yahtzee.Application.get_players
    game_loop(players)
    {winner, score} = calculate_winner(players)
    IO.puts("The winning player is #{winner} with a score of #{score}.")
    reset(players)
    again = String.trim(IO.gets("Play again? (y / n)\n"))
    IO.inspect(again)
    if again == "y" do
      start_game()
    end
  end

  def game_loop(players) do
    is_full = for player_name <- players do
      IO.puts("Current player: #{player_name}")
      state = YahtzeeTurn.get_state(YahtzeeTurn)
      score = take_turn(player_name, state, [])
      IO.inspect(score)
      YahtzeeTurn.reset(YahtzeeTurn)
      apply_score(player_name, score)
      is_full(player_name)
    end

    if Enum.member?(is_full, false) do
      game_loop(players)
    end
  end

  def take_turn(player_name, state, roll, keep \\ [])
  def take_turn(_player_name, state, roll, _keep) when state == :no_rolls do
    roll
  end

  def take_turn(player_name, state, _roll, keep) do
    new_roll = take_roll(player_name, keep)

    keep = if state != :one_roll do
      keep_indexes = IO.gets("what do you want to keep? Example: 'a b d' will keep 
      the first, second, and fourth dice.\n")
      keep_indexes = String.split(keep_indexes)
      get_dice(new_roll, keep_indexes)
    end

    state = case keep do
      keep when length(keep) == @dice_count ->
        YahtzeeTurn.end_turn(YahtzeeTurn)
        YahtzeeTurn.get_state(YahtzeeTurn)
      keep ->
        YahtzeeTurn.update_roll(YahtzeeTurn, keep)
        YahtzeeTurn.get_state(YahtzeeTurn)
    end

    take_turn(player_name, state, new_roll, keep)
  end

  def take_roll(player_name, keep) do
    roll = YahtzeeTurn.roll(keep) 
    IO.puts("Roll: #{inspect(roll)}")
    check = YahtzeeTurn.check(roll)
    print_scorecard(player_name)
    print_potential_scores(check)
    roll
  end

  def get_dice(roll, keep_indexes) do
    indexes = %{:a => Enum.at(roll, 0), :b => Enum.at(roll, 1),
    :c => Enum.at(roll, 2), :d => Enum.at(roll, 3), :e => Enum.at(roll, 4)}

    map_dice(keep_indexes, indexes)
  end

  def map_dice([], _indexes), do: []
  def map_dice([head | tail], indexes) do
    index = String.to_atom(head)
    key_in_indexes = Map.has_key?(indexes, index)
    case index do
      index when key_in_indexes ->
        value = Map.get(indexes, index)
        [value | map_dice(tail, indexes)]
      _index ->
        [map_dice(tail, indexes)]
    end
  end

  def apply_score(player_name, score) do
    category = IO.gets("Choose a category to score this turn:\n")
    score = YahtzeeTurn.sort(score)
    scorecard_id = YahtzeeScorecard.scorecard_name(player_name)
    {_scorecard, is_nil} = YahtzeeScorecard.update_card(scorecard_id, category, score)
    if !is_nil do
      IO.puts("This category has already been filled. Please choose again.")
      apply_score(player_name, score)
    end
  end

  def print_scorecard(player_name) do
    IO.puts("Your current scorecard:")
    scorecard_id = YahtzeeScorecard.scorecard_name(player_name)
    IO.inspect(YahtzeeScorecard.get_card(scorecard_id))
  end

  def print_potential_scores(scores) do
    IO.puts("Potential scores from this roll: \n #{inspect(scores)}")
  end

  def is_full(player_name) do
    scorecard_id = YahtzeeScorecard.scorecard_name(player_name)
    YahtzeeScorecard.is_full(scorecard_id)
  end

  def calculate_winner(players) do
    player_scores = Enum.reduce(players, %{}, fn player_name, acc ->
      scorecard_id = YahtzeeScorecard.scorecard_name(player_name)
      score = YahtzeeScorecard.calculate_score(scorecard_id)
      IO.puts("Player #{player_name} scored #{score}.")
      Map.put(acc, player_name, score)
    end)
    player_scores = Map.to_list(player_scores)
    max(player_scores)
  end

  def max([value]), do: value
  def max([{first_key, first_value}, {second_key, second_value} | tail]) do
    max([compare(first_key, first_value, second_key, second_value) | tail])
  end

  def compare(first_key, first_value, _second_key, second_value) when first_value > second_value, do: {first_key, first_value}
  def compare(_first_key, first_value, second_key, second_value) when first_value <= second_value, do: {second_key, second_value}

  def reset(players) do
    for player_name <- players do
      scorecard_id = YahtzeeScorecard.scorecard_name(player_name)
      YahtzeeScorecard.reset_card(scorecard_id)
    end
  end

end
