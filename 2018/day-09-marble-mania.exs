defmodule MarbleMania do
  def run do
    players = 413
    points = 71082

    players |> part_one(points) |> IO.inspect()
    players |> part_one(points) |> IO.inspect()
  end

  def part_one(players, points) do
    cicle = %{0 => %{prev: 1, next: 1}, 1 => %{prev: 0, next: 0}, :curr => 1}

    2..points
    |> Enum.reduce({%{}, cicle}, fn i, {scores, cicle} ->
      i |> rem(players) |> play(i, scores, cicle)
    end)
    |> elem(0)
    |> Map.values()
    |> Enum.max()
  end

  def part_two(players, points) do
    part_one(players, points * 100)
  end

  defp play(player, point, scores, cicle) when rem(point, 23) == 0 do
    cicle = Enum.reduce(1..7, cicle, fn _, acc -> counter_clockwise(acc) end)
    %{prev: prev, next: next} = cicle[cicle[:curr]]

    scores = Map.update(scores, player, point + cicle[:curr], &(&1 + point + cicle[:curr]))

    cicle =
      Map.merge(cicle, %{
        prev => Map.put(cicle[prev], :next, next),
        next => Map.put(cicle[next], :prev, prev),
        :curr => next
      })

    {scores, cicle}
  end

  defp play(_, point, scores, cicle) do
    prev = cicle |> clockwise() |> Map.get(:curr)
    next = cicle[prev][:next]

    cicle =
      Map.merge(cicle, %{
        prev => Map.put(cicle[prev], :next, point),
        point => %{prev: prev, next: next},
        next => Map.put(cicle[next], :prev, point),
        :curr => point
      })

    {scores, cicle}
  end

  defp clockwise(cicle), do: Map.update!(cicle, :curr, &cicle[&1][:next])

  defp counter_clockwise(cicle), do: Map.update!(cicle, :curr, &cicle[&1][:prev])
end

MarbleMania.run()
