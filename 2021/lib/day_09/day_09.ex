defmodule AOC2021.Day09 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    {grid, rows, cols} = init_grid(input)

    grid
    |> low_points(rows, cols)
    |> Enum.map(&(grid[&1] + 1))
    |> Enum.sum()
  end

  def part_two(input) do
    {grid, rows, cols} = init_grid(input)

    grid
    |> low_points(rows, cols)
    |> Enum.map(&(&1 |> largest_basin(grid) |> map_size()))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp largest_basin({row, col} = point, grid, acc \\ %{}) do
    if grid[point] && grid[point] < 9 && !acc[point] do
      acc = Map.put(acc, point, grid[point])

      Enum.reduce(
        [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}],
        acc,
        &largest_basin(&1, grid, &2)
      )
    else
      acc
    end
  end

  defp low_points(grid, rows, cols) do
    for row <- 1..rows, col <- 1..cols, reduce: [] do
      acc ->
        if Enum.all?(
             [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}],
             &(!grid[&1] || grid[&1] > grid[{row, col}])
           ) do
          [{row, col} | acc]
        else
          acc
        end
    end
  end

  def init_grid(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index(fn line, row ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index(fn number, col ->
          {{row + 1, col + 1}, String.to_integer(number)}
        end)
      end)

    rows = length(grid)
    cols = grid |> hd() |> length()

    grid = grid |> List.flatten() |> Map.new()
    {grid, rows, cols}
  end
end
