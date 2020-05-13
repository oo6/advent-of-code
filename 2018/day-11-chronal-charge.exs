defmodule ChronalCharge do
  def run() do
    input = 6392

    grid =
      for y <- 1..300, x <- 1..300 do
        id = x + 10
        count = (((id * y + input) * id / 100) |> trunc() |> rem(10)) - 5

        {{x, y}, count}
      end
      |> summed_area()

    grid |> part_one() |> IO.inspect()
    grid |> part_two() |> IO.inspect()
  end

  def part_one(grid) do
    {{x, y}, _, _} = max_area(grid, 3)

    "#{x},#{y}"
  end

  def part_two(grid) do
    {{x, y}, _, size} =
      1..300
      |> Enum.map(&max_area(grid, &1))
      |> Enum.max_by(&elem(&1, 1))

    "#{x},#{y},#{size}"
  end

  # https://en.wikipedia.org/wiki/Summed-area_table
  defp summed_area(grid) do
    Enum.reduce(grid, %{}, fn {{x, y}, count}, acc ->
      left = Map.get(acc, {x - 1, y}, 0)
      top = Map.get(acc, {x, y - 1}, 0)
      left_top = Map.get(acc, {x - 1, y - 1}, 0)

      Map.put(acc, {x, y}, count + left + top - left_top)
    end)
  end

  defp max_area(grid, size) do
    offset = size - 1

    for y <- 1..(300 - offset), x <- 1..(300 - offset) do
      left = Map.get(grid, {x - 1, y + offset}, 0)
      top = Map.get(grid, {x + offset, y - 1}, 0)
      left_top = Map.get(grid, {x - 1, y - 1}, 0)
      right_bottom = Map.get(grid, {x + offset, y + offset})

      {{x, y}, right_bottom - left - top + left_top, size}
    end
    |> Enum.max_by(&elem(&1, 1))
  end
end

ChronalCharge.run()
