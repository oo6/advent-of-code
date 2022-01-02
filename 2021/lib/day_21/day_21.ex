defmodule AOC2021.Day21 do
  import AOC2021.Day13, only: [rem_without_zero: 2]

  @pos_1 6
  @pos_2 1

  def run() do
    @pos_1 |> part_one(@pos_2) |> IO.inspect()
  end

  def part_one(pos_1, pos_2) do
    start_game({pos_1, 0}, {pos_2, 0}, {:player_1, 0})
  end

  defp start_game({_pos_1, score_1}, {_pos_2, score_2}, {_player, times}) when score_1 >= 1000 do
    score_2 * times
  end

  defp start_game({_pos_1, score_1}, {_pos_2, score_2}, {_player, times}) when score_2 >= 1000 do
    score_1 * times
  end

  defp start_game({pos_1, score_1}, player_2, {:player_1, times}) do
    pos = move(pos_1, times)
    start_game({pos, score_1 + pos}, player_2, {:player_2, times + 3})
  end

  defp start_game(player_1, {pos_2, score_2}, {:player_2, times}) do
    pos = move(pos_2, times)
    start_game(player_1, {pos, score_2 + pos}, {:player_1, times + 3})
  end

  defp move(pos, times) do
    [1, 2, 3]
    |> Enum.reduce(pos, &(rem_without_zero(times + &1, 100) + &2))
    |> rem_without_zero(10)
  end
end
