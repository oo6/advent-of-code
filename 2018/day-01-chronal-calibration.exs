defmodule ChronalCalibration do
  def run() do
    lines =
      "day-01-input.txt"
      |> File.read!()
      |> String.split("\n")
      |> List.delete("")

    lines |> part_one() |> IO.inspect()
    lines |> part_two() |> IO.inspect()
  end

  def part_one(lines) do
    Enum.reduce(lines, 0, fn line, acc -> acc + String.to_integer(line) end)
  end

  def part_two(lines, init \\ %{0 => true, "sum" => 0}) do
    result =
      Enum.reduce_while(lines, init, fn line, acc ->
        sum = acc["sum"] + String.to_integer(line)

        if acc[sum] do
          {:halt, sum}
        else
          {:cont, Map.merge(acc, %{sum => true, "sum" => sum})}
        end
      end)

    if is_integer(result), do: result, else: part_two(lines, result)
  end
end

ChronalCalibration.run()
