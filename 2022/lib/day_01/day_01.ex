defmodule AOC2022.Day01 do
  use AOC2022

  def part_one(input) do
    input
    |> String.split("\n")
    |> Enum.reduce([0], fn
      "", acc -> [0 | acc]
      num, [head | tail] -> [head + String.to_integer(num) | tail]
    end)
    |> Enum.max()
  end

  def part_two(input) do
    input
    |> String.split("\n")
    |> Enum.reduce([0], fn
      "", acc -> [0 | acc]
      num, [head | tail] -> [head + String.to_integer(num) | tail]
    end)
    |> Enum.sort(:desc)
    |> Enum.slice(0..2)
    |> Enum.sum()
  end
end
