defmodule AOC2022.Day06 do
  use AOC2022

  def part_one(input) do
    find_marker_index(input, 4) + 4
  end

  def part_two(input) do
    find_marker_index(input, 14) + 14
  end

  defp find_marker_index(input, length) do
    input
    |> String.split("", trim: true)
    |> Stream.chunk_every(length, 1, :discard)
    |> Enum.find_index(&(Enum.uniq(&1) == &1))
  end
end
