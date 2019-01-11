defmodule StarsAlign do
  def run do
    {points, count} =
      "day-10-input.txt"
      |> File.read!()
      |> String.split("\n")
      |> List.delete("")
      |> Enum.map(&parse/1)
      |> move()

    points |> part_one() |> Enum.each(&IO.inspect/1)
    count |> part_two() |> IO.inspect()
  end

  def part_one(points) do
    points = Enum.into(points, %{})

    {min_x, max_x} = points |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = points |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.min_max()

    for y <- min_y..max_y, x <- min_x..max_x do
      if Map.has_key?(points, {x, y}), do: "#", else: "."
    end
    |> Enum.chunk_every(max_x - min_x + 1)
    |> Enum.map(&Enum.join(&1, ""))
  end

  def part_two(count), do: count

  defp move(points, count \\ 0) do
    area = calc_area(points)
    new_points = Enum.map(points, fn {{x, y}, {v_x, v_y} = v} -> {{x + v_x, y + v_y}, v} end)

    if calc_area(new_points) > area, do: {points, count}, else: move(new_points, count + 1)
  end

  defp calc_area(points) do
    {min_x, max_x} = points |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.min_max()
    {min_y, max_y} = points |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.min_max()

    (max_x - min_x) * (max_y - min_y)
  end

  defp parse(line) do
    [x, y, v_x, v_y] =
      line
      |> String.split(["position=<", ", ", "> velocity=<", ", ", ">"], trim: true)
      |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))

    {{x, y}, {v_x, v_y}}
  end
end

StarsAlign.run()
