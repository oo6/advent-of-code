defmodule NoMatterHowSlice do
  def run do
    lines =
      "input.txt"
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&parse(&1))

    fabric = lines |> Enum.reduce(%{}, &cut(&2, &1))

    fabric |> part_one() |> IO.inspect()
    fabric |> part_two(lines) |> IO.inspect()
  end

  def part_one(fabric) do
    fabric
    |> Enum.into([])
    |> Enum.reduce(0, fn
      {_, ids}, acc when length(ids) > 1 -> acc + 1
      _, acc -> acc
    end)
  end

  def part_two(fabric, lines) do
    lines
    |> Enum.find(&match(fabric, &1))
    |> Keyword.get(:id)
  end

  defp parse(line) do
    [id, left, top, width, height] =
      line
      |> String.split(["#", " @ ", ",", ": ", "x"], trim: true)
      |> Enum.map(&String.to_integer/1)

    [left: left, top: top, width: width, height: height, id: id]
  end

  defp cut(fabric, left: left, top: top, width: width, height: height, id: id) do
    Enum.reduce(left..(left + width - 1), fabric, fn x, outer_acc ->
      Enum.reduce(top..(top + height - 1), outer_acc, fn y, inner_acc ->
        Map.update(inner_acc, {x, y}, [id], &[id | &1])
      end)
    end)
  end

  defp match(fabric, left: left, top: top, width: width, height: height, id: id) do
    Enum.all?(left..(left + width - 1), fn x ->
      Enum.all?(top..(top + height - 1), fn y ->
        fabric[{x, y}] == [id]
      end)
    end)
  end
end

NoMatterHowSlice.run()
