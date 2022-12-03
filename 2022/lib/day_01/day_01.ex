defmodule AOC2022.Day01 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

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
