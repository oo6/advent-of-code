defmodule AOC2021.Day13 do
  def run() do
    dots = "dots.txt" |> Path.expand(__DIR__) |> File.read!()
    folds = "folds.txt" |> Path.expand(__DIR__) |> File.read!()

    dots |> part_one(folds) |> IO.inspect()
    dots |> part_two(folds)
  end

  def part_one(dots, folds) do
    dots = normalize_dots(dots)

    folds
    |> String.split("\n", trim: true)
    |> Enum.at(0)
    |> fold(dots)
    |> MapSet.size()
  end

  def part_two(dots, folds) do
    dots = normalize_dots(dots)

    folds
    |> String.split("\n", trim: true)
    |> Enum.reduce(dots, &fold(&1, &2))
    |> print()
  end

  defp normalize_dots(dots) do
    dots
    |> String.split("\n", trim: true)
    |> Enum.reduce(MapSet.new(), fn dot, acc ->
      [x, y] = dot |> String.split(",") |> Enum.map(&String.to_integer/1)
      MapSet.put(acc, {x, y})
    end)
  end

  defp print(dots) do
    {max_x, _} = dots |> MapSet.to_list() |> Enum.max_by(&elem(&1, 0))
    {_, max_y} = dots |> MapSet.to_list() |> Enum.max_by(&elem(&1, 1))

    Enum.each(0..max_y, fn y ->
      0..max_x
      |> Enum.map(fn x -> if {x, y} in dots, do: "#", else: "." end)
      |> Enum.join()
      |> IO.inspect()
    end)
  end

  defp fold("fold along x=" <> line, dots) do
    line = String.to_integer(line)

    Enum.reduce(dots, MapSet.new(), fn
      {^line, _y}, acc -> acc
      {x, y}, acc when x < line -> MapSet.put(acc, {x, y})
      {x, y}, acc -> MapSet.put(acc, {line - rem_without_zero(x, line), y})
    end)
  end

  defp fold("fold along y=" <> line, dots) do
    line = String.to_integer(line)

    Enum.reduce(dots, MapSet.new(), fn
      {_x, ^line}, acc -> acc
      {x, y}, acc when y < line -> MapSet.put(acc, {x, y})
      {x, y}, acc -> MapSet.put(acc, {x, line - rem_without_zero(y, line)})
    end)
  end

  def rem_without_zero(dividend, divisor) do
    case rem(dividend, divisor) do
      0 -> divisor
      remainder -> remainder
    end
  end
end
