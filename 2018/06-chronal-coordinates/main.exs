defmodule ChronalCoordinates do
  def run do
    coords =
      "input.txt"
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ", ")
        {String.to_integer(x), String.to_integer(y)}
      end)

    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coords, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coords, &elem(&1, 1))
    range_x = min_x..max_x
    range_y = min_y..max_y

    coords |> part_one(range_x, range_y) |> IO.inspect()
    coords |> part_two(range_x, range_y) |> IO.inspect()
  end

  def part_one(coords, range_x, range_y) do
    grid =
      for x1 <- range_x,
          y1 <- range_y,
          into: %{} do
        p =
          coords
          |> Enum.map(fn {x2, y2} = p -> {abs(x1 - x2) + abs(y1 - y2), p} end)
          |> Enum.sort()
          |> case do
            [{d, _}, {d, _} | _] -> nil
            [{_, p} | _] -> p
          end

        {{x1, y1}, p}
      end

    infinite_for_x =
      for y <- [range_y.first, range_y.last],
          x <- range_x,
          p = grid[{x, y}],
          do: p

    infinite_for_y =
      for x <- [range_x.first, range_x.last],
          y <- range_y,
          p = grid[{x, y}],
          do: p

    infinite = Enum.uniq(infinite_for_x ++ infinite_for_y)

    grid
    |> Enum.reject(fn {_, p} -> p == nil || p in infinite end)
    |> Enum.reduce(%{}, fn {_, p}, acc -> Map.update(acc, p, 1, &(&1 + 1)) end)
    |> Map.values()
    |> Enum.max()
  end

  def part_two(coords, range_x, range_y) do
    for x1 <- range_x, y1 <- range_y do
      sum =
        coords
        |> Enum.map(fn {x2, y2} -> abs(x1 - x2) + abs(y1 - y2) end)
        |> Enum.sum()

      if sum < 10000, do: 1, else: 0
    end
    |> Enum.sum()
  end
end

ChronalCoordinates.run()
