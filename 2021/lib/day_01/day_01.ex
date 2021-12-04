defmodule AOC2021.Day01 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [first, last] -> last > first end)
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.count(fn [first, _, _, last] -> last > first end)
  end
end
