defmodule AOC2021.Day15 do
  import AOC2021.Day09, only: [init_grid: 1]

  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    {grid, rows, cols} = init_grid(input)
    dijkstra(%{{1, 1} => 0}, grid)[{rows, cols}]
  end

  def part_two(input) do
    {grid, rows, cols} = init_grid(input)

    grid =
      for offset_x <- 0..4, offset_y <- 0..4, {offset_x, offset_y} == {0, 0} do
        Map.new(grid, fn {{x, y}, value} ->
          point = {x + rows * offset_x, y + cols * offset_y}

          value = value + offset_x + offset_y
          value = if value <= 9, do: value, else: rem(value, 9)

          {point, value}
        end)
      end
      |> Enum.reduce(grid, &Map.merge(&1, &2))

    dijkstra(%{{1, 1} => 0}, grid)[{rows * 5, cols * 5}]
  end

  # https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
  defp dijkstra(unvisited, grid, known \\ %{})
  defp dijkstra(unvisited, _grid, known) when map_size(unvisited) == 0, do: known

  defp dijkstra(unvisited, grid, known) do
    {{x, y} = min_point, min_distance} = Enum.min_by(unvisited, &elem(&1, 1))
    known = Map.put(known, min_point, min_distance)

    %{{x - 1, y} => nil, {x + 1, y} => nil, {x, y - 1} => nil, {x, y + 1} => nil}
    |> Map.merge(unvisited)
    |> Enum.reduce([], fn
      {point, _}, acc when is_map_key(known, point) or not is_map_key(grid, point) ->
        acc

      {{x1, y1} = point, distance}, acc when abs(x1 - x) + abs(y1 - y) == 1 ->
        new_distance = min_distance + grid[point]
        distance = if new_distance < distance, do: new_distance, else: distance
        [{point, distance} | acc]

      {point, distance}, acc ->
        [{point, distance} | acc]
    end)
    |> Map.new()
    |> dijkstra(grid, known)
  end
end
