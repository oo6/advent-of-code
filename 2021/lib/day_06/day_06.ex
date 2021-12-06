defmodule AOC2021.Day06 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!() |> String.replace("\n", "")

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    produce(input, 80)
  end

  def part_two(input) do
    produce(input, 256)
  end

  defp produce(input, day) do
    input
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
    |> Enum.map(fn {timer, times} ->
      count = timer |> do_produce(day) |> elem(0)
      count * times
    end)
    |> Enum.sum()
  end

  defp do_produce(timer, day, cache \\ %{})
  defp do_produce(timer, day, cache) when timer >= day, do: {1, cache}

  defp do_produce(_timer, day, cache) when is_map_key(cache, day), do: {cache[day], cache}

  defp do_produce(timer, day, cache) do
    next_day = day - (timer + 1)

    {first, cache} = do_produce(6, next_day, cache)
    {second, cache} = do_produce(6, next_day - 2, cache)

    count = first + second
    {count, Map.put(cache, day, count)}
  end
end
