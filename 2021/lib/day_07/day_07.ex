defmodule AOC2021.Day07 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!() |> String.replace("\n", "")

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    positions =
      input
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()

    median = Enum.at(positions, floor(length(positions) / 2))
    Enum.reduce(positions, 0, &(&2 + abs(&1 - median)))
  end

  def part_two(input) do
    positions =
      input
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    average = Enum.sum(positions) / length(positions)

    [floor(average), ceil(average)]
    |> Enum.map(fn number -> Enum.reduce(positions, 0, &(&2 + Enum.sum(1..abs(&1 - number)))) end)
    |> Enum.min()
  end
end
