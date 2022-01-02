defmodule AOC2021.Day12 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    rules = init_rules(input)

    allow_visit? = fn cave, path ->
      Enum.any?([&big_cave?/2, &first_visit?/2], &apply(&1, [cave, path]))
    end

    {"start", allow_visit?} |> visit(rules) |> length()
  end

  def part_two(input) do
    rules = init_rules(input)

    allow_visit? = fn cave, path ->
      Enum.any?([&big_cave?/2, &first_visit?/2, &twice_visit?/2], &apply(&1, [cave, path]))
    end

    {"start", allow_visit?} |> visit(rules) |> length()
  end

  defp big_cave?(cave, _path), do: cave == String.upcase(cave)
  defp first_visit?(cave, path), do: cave not in path

  defp twice_visit?(_cave, path) do
    path
    |> Enum.filter(&(String.upcase(&1) != &1))
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.all?(&(&1 < 2))
  end

  def visit({cave, allow_visit?}, rules, path \\ []) do
    if apply(allow_visit?, [cave, path]) do
      path = [cave | path]

      Enum.reduce(rules[cave], [], fn
        "end", acc -> [["end" | path] | acc]
        cave, acc -> visit({cave, allow_visit?}, rules, path) ++ acc
      end)
    else
      []
    end
  end

  defp init_rules(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [left, right] = String.split(line, "-")

      acc =
        if left != "end" && right != "start" do
          Map.update(acc, left, [right], &[right | &1])
        else
          acc
        end

      if left != "start" && right != "end" do
        Map.update(acc, right, [left], &[left | &1])
      else
        acc
      end
    end)
  end
end
