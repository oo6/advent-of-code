defmodule AOC2021.Day11Test do
  use ExUnit.Case, async: true

  @input """
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
  """

  test "part_one success" do
    assert 1656 == AOC2021.Day11.part_one(@input)
  end

  test "part_two success" do
    assert 195 == AOC2021.Day11.part_two(@input)
  end
end
