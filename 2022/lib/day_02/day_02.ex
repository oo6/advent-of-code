defmodule AOC2022.Day02 do
  use AOC2022

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [oppoent, self] = String.split(line, " ")
      oppoent = :binary.first(oppoent) - 64
      self = :binary.first(self) - 87

      outcome =
        case oppoent - self do
          # A X, B Y, C Z
          0 -> 3
          # B X, C Y
          1 -> 0
          # A Z
          -2 -> 0
          # A Y, B Z
          -1 -> 6
          # C X
          2 -> 6
        end

      outcome + self
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [oppoent, self] = String.split(line, " ")
      oppoent = :binary.first(oppoent) - 64

      case self do
        "X" -> rem_without_zero(oppoent - 1, 3)
        "Y" -> 3 + oppoent
        "Z" -> 6 + rem_without_zero(oppoent + 1, 3)
      end
    end)
    |> Enum.sum()
  end

  def rem_without_zero(dividend, divisor) do
    case rem(dividend, divisor) do
      0 -> divisor
      remainder -> remainder
    end
  end
end
