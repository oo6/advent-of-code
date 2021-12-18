defmodule AOC2021.Day15Test do
  use ExUnit.Case, async: true

  @input """
  1163751742
  1381373672
  2136511328
  3694931569
  7463417111
  1319128137
  1359912421
  3125421639
  1293138521
  2311944581
  """

  test "part_one success" do
    assert 40 == AOC2021.Day15.part_one(@input)
  end

  test "part_two success" do
    assert 315 == AOC2021.Day15.part_two(@input)
  end
end
