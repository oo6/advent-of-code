defmodule AOC2021.Day17 do
  @range_x 209..238
  @range_y -86..-59

  def run() do
    @range_y |> part_one() |> IO.inspect()
    @range_x |> part_two(@range_y) |> IO.inspect()
  end

  def part_one(%{first: first}) do
    Enum.sum(1..abs(first + 1))
  end

  def part_two(%{last: max_x} = range_x, %{first: min_y} = range_y) do
    results =
      for vx <- 0..max_x, vy <- min_y..abs(min_y + 1), hit?({vx, vy}, {range_x, range_y}) do
        {vx, vy}
      end

    length(results)
  end

  # https://github.com/josevalim/aoc/blob/main/2021/day-17.livemd#part-2
  defp shot({vx, vy}, {%{last: max_x}, %{first: min_y}}) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.transform({0, 0, vx, vy}, fn _, {x, y, vx, vy} ->
      {[{x, y}], {x + vx, y + vy, max(vx - 1, 0), vy - 1}}
    end)
    |> Stream.take_while(fn {x, y} -> x <= max_x and y >= min_y end)
  end

  defp hit?({vx, vy}, {range_x, range_y}) do
    {x, y} = shot({vx, vy}, {range_x, range_y}) |> Enum.at(-1)
    x in range_x and y in range_y
  end
end
