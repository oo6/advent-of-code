defmodule AOC2022.Day04 do
  use AOC2022

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn line ->
      [first, second, third, fourth] =
        line
        |> String.split(["-", ","])
        |> Enum.map(&String.to_integer/1)

      # first..third..fourth..second
      # third..first..second..fourth
      contain({first, second}, {third, fourth})
    end)
    |> length()
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(fn line ->
      [first, second, third, fourth] =
        line
        |> String.split(["-", ","])
        |> Enum.map(&String.to_integer/1)

      # third..first..fourth..second
      # first..third..second..fourth
      # first..third..fourth..second
      # third..first..second..fourth
      first in third..fourth or
        second in third..fourth or
        contain({first, second}, {third, fourth})
    end)
    |> length()
  end

  defp contain({first, second}, {third, fourth}) do
    (first <= third and second >= fourth) or (first >= third and second <= fourth)
  end
end
