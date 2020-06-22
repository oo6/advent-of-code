defmodule MineCartMadness do
  def run do
    {grid, carts} =
      "input.txt"
      |> File.read!()
      |> String.split("\n")
      |> parse()

    carts |> part_one(grid) |> IO.inspect()
    carts |> part_two(grid) |> IO.inspect()
  end

  def part_one(carts, grid) do
    move(:halt, carts, grid)
  end

  def part_two(carts, grid) do
    move(:cont, carts, grid)
  end

  def move(type, carts, grid) do
    carts =
      Enum.reduce(carts, carts, fn {coord, cart}, acc ->
        if acc[coord], do: do_move(type, {coord, cart}, acc, grid), else: acc
      end)

    case Map.keys(carts) do
      [{x, y}] -> "#{x},#{y}"
      _ -> move(type, carts, grid)
    end
  end

  def do_move(:halt, {coord, cart}, carts, grid) do
    carts = Map.delete(carts, coord)
    coord = cart |> elem(0) |> next(coord)

    if carts[coord] do
      %{coord => nil}
    else
      Map.put(carts, coord, turn(cart, grid[coord]))
    end
  end

  def do_move(:cont, {coord, cart}, carts, grid) do
    carts = Map.delete(carts, coord)
    coord = cart |> elem(0) |> next(coord)

    if carts[coord] do
      Map.delete(carts, coord)
    else
      Map.put(carts, coord, turn(cart, grid[coord]))
    end
  end

  def next("^", {x, y}), do: {x, y - 1}
  def next(">", {x, y}), do: {x + 1, y}
  def next("v", {x, y}), do: {x, y + 1}
  def next("<", {x, y}), do: {x - 1, y}

  def turn({"^", count}, "\\"), do: {"<", count}
  def turn({"^", count}, "/"), do: {">", count}
  def turn({">", count}, "\\"), do: {"v", count}
  def turn({">", count}, "/"), do: {"^", count}
  def turn({"v", count}, "\\"), do: {">", count}
  def turn({"v", count}, "/"), do: {"<", count}
  def turn({"<", count}, "\\"), do: {"^", count}
  def turn({"<", count}, "/"), do: {"v", count}

  def turn({"^", count}, "+"), do: {Enum.at(["<", "^", ">"], rem(count, 3)), count + 1}
  def turn({">", count}, "+"), do: {Enum.at(["^", ">", "v"], rem(count, 3)), count + 1}
  def turn({"v", count}, "+"), do: {Enum.at([">", "v", "<"], rem(count, 3)), count + 1}
  def turn({"<", count}, "+"), do: {Enum.at(["v", "<", "^"], rem(count, 3)), count + 1}

  def turn(cart, "-"), do: cart
  def turn(cart, "|"), do: cart

  def parse(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce({%{}, %{}}, fn {line, y}, outer_acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(outer_acc, fn
        {" ", _}, inner_acc ->
          inner_acc

        {item, x}, {grid, carts} when item in ["^", ">", "v", "<"] ->
          coord = {x, y}

          {
            Map.put(grid, coord, if(item in ["^", "v"], do: "|", else: "-")),
            Map.put(carts, coord, {item, 0})
          }

        {item, x}, {grid, carts} ->
          {Map.put(grid, {x, y}, item), carts}
      end)
    end)
  end
end

MineCartMadness.run()
