defmodule AOC2021.Day08 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" | ")
      |> List.last()
      |> String.split(" ")
      |> Enum.map(&String.length/1)
    end)
    |> List.flatten()
    |> Enum.count(&(&1 in [2, 3, 4, 7]))
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [numbers, output] = String.split(line, " | ")
      numbers = compute(numbers)

      output
      |> String.split(" ")
      |> Enum.map(fn number ->
        segments = number |> String.split("", trim: true) |> Enum.sort()
        numbers[segments]
      end)
      |> Enum.join()
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp compute(numbers) do
    numbers = numbers |> String.split(" ") |> Enum.map(&String.split(&1, "", trim: true))

    known =
      Map.new([{"1", 2}, {"4", 4}, {"7", 3}, {"8", 7}], fn {key, value} ->
        {key, Enum.find(numbers, &(length(&1) == value))}
      end)

    segments =
      [:top, :bottom, :center, :left_top, :left_bottom, :right_top, :right_bottom]
      |> Enum.reduce(%{}, fn pos, acc ->
        segment = pos |> rule(numbers, known, acc) |> do_compute()
        Map.put(acc, pos, segment)
      end)

    [
      {"0", [:top, :left_top, :left_bottom, :bottom, :right_bottom, :right_top]},
      {"2", [:top, :right_top, :center, :left_bottom, :bottom]},
      {"3", [:top, :right_top, :center, :right_bottom, :bottom]},
      {"5", [:top, :left_top, :center, :right_bottom, :bottom]},
      {"6", [:top, :left_top, :left_bottom, :bottom, :right_bottom, :center]},
      {"9", [:top, :left_top, :center, :right_top, :right_bottom, :bottom]}
    ]
    |> Enum.reduce(known, fn {number, positions}, acc ->
      Map.put(acc, number, Enum.map(positions, &segments[&1]))
    end)
    |> Map.new(fn {number, segments} -> {Enum.sort(segments), number} end)
  end

  defp do_compute({inputs, rule}) do
    Enum.find_value(inputs, fn input ->
      case input -- rule do
        [segment] -> segment
        _ -> nil
      end
    end)
  end

  defp rule(:top, _numbers, known, _segments), do: {[known["7"]], known["1"]}
  defp rule(:bottom, numbers, known, segments), do: {numbers, [segments.top | known["4"]]}
  defp rule(:center, numbers, known, segments), do: {numbers, [segments.bottom | known["7"]]}

  defp rule(:left_top, _numbers, known, segments),
    do: {[known["4"]], [segments.center | known["1"]]}

  defp rule(:left_bottom, _numbers, known, segments),
    do: {[known["8"]], [segments.top, segments.bottom | known["4"]]}

  defp rule(:right_top, numbers, _known, segments),
    do: {numbers, [segments.top, segments.center, segments.left_bottom, segments.bottom]}

  defp rule(:right_bottom, _numbers, known, segments),
    do: {[known["1"]], [segments.right_top]}
end
