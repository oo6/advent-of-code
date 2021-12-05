defmodule AOC2021.Day05 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    input
    |> String.split(["\n", ",", " -> "], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4, 4)
    |> Enum.reduce(%{}, fn
      [x, y1, x, y2], acc -> Enum.reduce(y1..y2, acc, &update(&2, {x, &1}))
      [x1, y, x2, y], acc -> Enum.reduce(x1..x2, acc, &update(&2, {&1, y}))
      _, acc -> acc
    end)
    |> Enum.count(fn {_key, value} -> value >= 2 end)
  end

  def part_two(input) do
    input
    |> String.split(["\n", ",", " -> "], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4, 4)
    |> Enum.reduce(%{}, fn
      [x, y1, x, y2], acc ->
        Enum.reduce(y1..y2, acc, &update(&2, {x, &1}))

      [x1, y, x2, y], acc ->
        Enum.reduce(x1..x2, acc, &update(&2, {&1, y}))

      [x1, y1, x2, y2], acc when abs(x1 - x2) == abs(y1 - y2) ->
        [x1..x2, y1..y2]
        |> Enum.zip()
        |> Enum.reduce(acc, &update(&2, &1))

      _, acc ->
        acc
    end)
    |> Enum.count(fn {_key, value} -> value >= 2 end)
  end

  defp update(map, {x, y}), do: Map.update(map, {x, y}, 1, &(&1 + 1))
end
