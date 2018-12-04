defmodule InventoryManagementSystem do
  def run do
    lines =
      "day-02-input.txt"
      |> File.read!()
      |> String.split("\n")
      |> List.delete("")
      |> Enum.map(&String.split(&1, "", trim: ""))

    lines |> part_one() |> IO.inspect()
    lines |> part_two() |> IO.inspect()
  end

  def part_one(lines) do
    counts =
      Enum.reduce(lines, %{"2" => 0, "3" => 0}, fn chars, acc ->
        {a, b} =
          chars
          |> Enum.reduce({0, 0}, fn char, acc ->
            chars
            |> Enum.count(&(&1 == char))
            |> case do
              2 -> {1, elem(acc, 1)}
              3 -> {elem(acc, 0), 1}
              _ -> acc
            end
          end)

        %{"2" => acc["2"] + a, "3" => acc["3"] + b}
      end)

    counts["2"] * counts["3"]
  end

  def part_two(lines), do: lines |> find_value() |> Enum.join("")

  def find_value([head | tail]) when not is_nil(tail),
    do: Enum.find_value(tail, &differ_by_one_character?(head, &1)) || find_value(tail)

  def find_value(_), do: []

  def differ_by_one_character?(list1, list2, acc \\ [], count \\ 0)

  def differ_by_one_character?([], [], acc, 1), do: Enum.reverse(acc)

  def differ_by_one_character?([], [], _, _), do: nil

  def differ_by_one_character?([head | tail1], [head | tail2], acc, count),
    do: differ_by_one_character?(tail1, tail2, [head | acc], count)

  def differ_by_one_character?([_ | tail1], [_ | tail2], acc, count),
    do: differ_by_one_character?(tail1, tail2, acc, count + 1)
end

InventoryManagementSystem.run()
