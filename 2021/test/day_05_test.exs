defmodule AOC2021.Day05Test do
  use ExUnit.Case, async: true

  @input """
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  """

  test "part_one success" do
    assert 5 == AOC2021.Day05.part_one(@input)
  end

  test "part_two success" do
    assert 12 == AOC2021.Day05.part_two(@input)
  end
end
