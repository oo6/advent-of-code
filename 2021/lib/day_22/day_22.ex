defmodule AOC2021.Day22 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
  end

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
    |> Enum.filter(fn {type, ranges} ->
      unless Enum.any?(ranges, &Range.disjoint?(&1, -50..50)) do
        ranges = Enum.map(ranges, &Range.new(max(&1.first, -50), min(&1.last, 50)))
        {type, ranges}
      end
    end)
    |> Enum.reduce(MapSet.new(), &turn/2)
    |> MapSet.size()
  end

  defp turn({type, [range_x, range_y, range_z]}, cubes) do
    for x <- range_x, y <- range_y, z <- range_z do
      {x, y, z}
    end
    |> Enum.reduce(cubes, &apply(MapSet, if(type == "on", do: :put, else: :delete), [&2, &1]))
  end

  defp parse(line) do
    [type | ranges] = String.split(line, [" ", ","])
    ranges = Enum.map(ranges, &(&1 |> String.slice(2..-1) |> Code.eval_string() |> elem(0)))
    {type, ranges}
  end
end
