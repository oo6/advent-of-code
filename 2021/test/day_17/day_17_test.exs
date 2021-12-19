defmodule AOC2021.Day17Test do
  use ExUnit.Case, async: true

  @range_x 20..30
  @range_y -10..-5

  test "part_one success" do
    assert 45 == AOC2021.Day17.part_one(@range_y)
  end

  test "part_two success" do
    assert 112 == AOC2021.Day17.part_two(@range_x, @range_y)
  end
end
