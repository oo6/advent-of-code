defmodule AOC2021.Day09Test do
  use ExUnit.Case, async: true

  @input """
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  """

  test "part_one success" do
    assert 15 == AOC2021.Day09.part_one(@input)
  end

  test "part_two success" do
    assert 1134 == AOC2021.Day09.part_two(@input)
  end
end
