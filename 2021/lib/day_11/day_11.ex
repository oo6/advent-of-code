defmodule AOC2021.Day11 do
  import AOC2021.Day09, only: [init_grid: 1]

  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    {grid, _rows, _cols} = init_grid(input)

    grid
    |> next_step(fn steps, _ -> steps == 100 end)
    |> elem(1)
  end

  def part_two(input) do
    {grid, _rows, _cols} = init_grid(input)

    grid
    |> next_step(fn _, grid -> Enum.all?(grid, &(elem(&1, 1) == 0)) end)
    |> elem(0)
  end

  defp next_step(grid, stop?, {steps, count} \\ {0, 0}) do
    {grid, flashed} =
      Enum.reduce(grid, {grid, %{}}, fn
        {point, 9}, acc -> flash(point, acc)
        _, acc -> acc
      end)

    grid = Map.map(grid, fn {point, level} -> if flashed[point], do: 0, else: level + 1 end)
    steps = steps + 1
    count = count + map_size(flashed)

    if apply(stop?, [steps, grid]) do
      {steps, count}
    else
      next_step(grid, stop?, {steps, count})
    end
  end

  defp flash({row, col} = point, {grid, flashed})
       when is_map_key(grid, point) and not is_map_key(flashed, point) do
    grid = Map.update!(grid, point, &(&1 + 1))

    if grid[point] >= 9 do
      flashed = Map.put(flashed, point, true)

      Enum.reduce(
        [
          {row - 1, col - 1},
          {row - 1, col},
          {row - 1, col + 1},
          {row, col - 1},
          {row, col + 1},
          {row + 1, col - 1},
          {row + 1, col},
          {row + 1, col + 1}
        ],
        {grid, flashed},
        &flash(&1, &2)
      )
    else
      {grid, flashed}
    end
  end

  defp flash(_, {grid, flashed}), do: {grid, flashed}
end
