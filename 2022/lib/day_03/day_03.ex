defmodule AOC2022.Day03 do
  use AOC2022

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split_at(div(String.length(line), 2))
      |> Tuple.to_list()
      |> find_letter_priority()
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&find_letter_priority/1)
    |> Enum.sum()
  end

  defp find_letter_priority(group) do
    group
    |> Enum.map(&(&1 |> String.to_charlist() |> Enum.uniq()))
    |> Enum.concat()
    |> Enum.frequencies()
    |> Enum.find_value(&if(elem(&1, 1) == length(group), do: elem(&1, 0)))
    |> case do
      letter when letter in ?a..?z -> letter - ?a + 1
      letter when letter in ?A..?Z -> letter - ?A + 27
    end
  end
end
