defmodule InventoryManagementSystem do
  def run do
    lines =
      "day-02-input.txt"
      |> File.read!()
      |> String.split("\n")
      |> List.delete("")

    lines |> part_one() |> IO.inspect()
  end

  def part_one(lines) do
    counts =
      Enum.reduce(lines, %{"2" => 0, "3" => 0}, fn line, acc ->
        items = String.split(line, "", trim: "")

        {a, b} =
          items
          |> Enum.reduce({0, 0}, fn char, acc ->
            items
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
end

InventoryManagementSystem.run()
