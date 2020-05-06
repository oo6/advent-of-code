defmodule BeverageBandits do
  def run do
    {grid, units} =
      "#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######"
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce({%{}, []}, fn {line, y}, acc ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {item, x}, {grid, units} ->
          grid = Map.put(grid, {x, y}, item)
          units = if item in ["E", "G"], do: [{{x, y}, 200} | units], else: units

          {grid, units}
        end)
      end)

    units = Enum.reverse(units)

    units |> part_one(grid) |> IO.inspect()
  end

  def part_one(units, grid) do
    {units, _} = move_and_attack(units, grid)
    units
  end

  defp move_and_attack(units, grid, n \\ 1)
  defp move_and_attack(units, grid, 24), do: {units, grid}

  defp move_and_attack(units, grid, n) do
    {units, grid} =
      {units, grid}
      |> move(n)
      |> attack(n)

    move_and_attack(units, grid, n + 1)
  end

  defp attack({units, grid}, _n) do
    Enum.reduce(units, {units, grid}, fn {{x, y} = curr, _}, {units, grid} ->
      acc = []

      top = {x, y - 1}

      acc =
        if grid[top] not in [".", "#", grid[curr]],
          do: [{hp(top, units), top} | acc],
          else: acc

      bottom = {x, y + 1}

      acc =
        if grid[bottom] not in [".", "#", grid[curr]],
          do: [{hp(bottom, units), bottom} | acc],
          else: acc

      left = {x - 1, y}

      acc =
        if grid[left] not in [".", "#", grid[curr]],
          do: [{hp(left, units), left} | acc],
          else: acc

      right = {x + 1, y}

      acc =
        if grid[right] not in [".", "#", grid[curr]],
          do: [{hp(right, units), right} | acc],
          else: acc

      acc
      |> Enum.sort(fn {hp1, {_, y1}}, {hp2, {_, y2}} -> hp1 < hp2 || (hp1 == hp2 && y1 < y2) end)
      |> case do
        [{_, target} | _] ->
          {units, grid} =
            units
            |> Enum.reduce({[], grid}, fn
              {^target, hp}, {units, grid} when hp > 3 ->
                {[{target, hp - 3} | units], grid}

              {^target, _}, {units, grid} ->
                grid = Map.put(grid, target, ".")
                {units, grid}

              unit, {units, grid} ->
                {[unit | units], grid}
            end)

          {Enum.reverse(units), grid}

        _ ->
          {units, grid}
      end
    end)
  end

  defp move({units, grid}, _n) do
    Enum.reduce(units, {units, grid}, fn {curr, _}, {units, grid} ->
      units
      |> Enum.filter(fn {pos, _} -> grid[pos] != grid[curr] end)
      |> Enum.reduce([], fn {{x, y}, _}, acc ->
        top = {x, y - 1}

        acc =
          if grid[top] == "." || top == curr,
            do: [{distance(curr, top), top} | acc],
            else: acc

        bottom = {x, y + 1}

        acc =
          if grid[bottom] == "." || bottom == curr,
            do: [{distance(curr, bottom), bottom} | acc],
            else: acc

        left = {x - 1, y}

        acc =
          if grid[left] == "." || left == curr,
            do: [{distance(curr, left), left} | acc],
            else: acc

        right = {x + 1, y}

        if grid[right] == "." || right == curr,
          do: [{distance(curr, right), right} | acc],
          else: acc
      end)
      |> Enum.sort(fn {d1, {_, y1}}, {d2, {_, y2}} -> d1 < d2 || (d1 == d2 && y1 < y2) end)
      |> case do
        [{distance, target} | _] when distance != 0 ->
          next = next(curr, target)

          units =
            Enum.map(units, fn
              {^curr, ph} -> {next, ph}
              unit -> unit
            end)

          grid = grid |> Map.put(curr, ".") |> Map.put(next, grid[curr])

          {units, grid}

        _ ->
          {units, grid}
      end
    end)
  end

  defp next({x1, y}, {x2, y}) when x1 < x2, do: {x1 + 1, y}
  defp next({x, y}, {_, y}), do: {x - 1, y}
  defp next({x, y1}, {x, y2}) when y1 < y2, do: {x, y1 + 1}
  defp next({x, y}, {x, _}), do: {x, y - 1}

  defp next({x, y1}, {_, y2}) when y1 > y2, do: {x, y1 - 1}
  defp next({x1, y}, {x2, _}) when x1 < x2, do: {x1 + 1, y}
  defp next({x, y}, _), do: {x - 1, y}

  defp distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp hp(pos, units) do
    {_, hp} = Enum.find(units, &(elem(&1, 0) == pos))
    hp
  end
end

BeverageBandits.run()
