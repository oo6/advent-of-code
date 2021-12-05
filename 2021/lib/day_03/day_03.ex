defmodule AOC2021.Day03 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    [number | _] = bits = String.split(input, "\n", trim: true)

    gamma =
      bits
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.zip_with(& &1)
      |> Enum.reduce("", fn bits, gamma ->
        counts = Enum.frequencies(bits)
        gamma <> if counts["0"] > counts["1"], do: "0", else: "1"
      end)
      |> String.to_integer(2)

    epsilon =
      gamma
      |> Bitwise.bnot()
      |> Bitwise.band(2 ** String.length(number) - 1)

    gamma * epsilon
  end

  def part_two(input) do
    bits = String.split(input, "\n", trim: true)

    [&if(&2 >= &1, do: "1", else: "0"), &if(&1 <= &2, do: "0", else: "1")]
    |> Enum.map(&(bits |> filter(0, &1) |> String.to_integer(2)))
    |> Enum.product()
  end

  defp filter([last], _index, _fun), do: last

  defp filter(bits, index, fun) do
    counts = Enum.frequencies_by(bits, &String.at(&1, index))

    bits
    |> Enum.filter(&(String.at(&1, index) == apply(fun, [counts["0"], counts["1"]])))
    |> filter(index + 1, fun)
  end
end
