defmodule AOC2021.Day13Test do
  use ExUnit.Case, async: true

  @dots """
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0
  """

  @folds """
  fold along y=7
  fold along x=5
  """

  test "part_one success" do
    assert 17 == AOC2021.Day13.part_one(@dots, @folds)
  end

  test "part_two success" do
    assert AOC2021.Day13.part_two(@dots, @folds)
  end
end
