defmodule AOC2022.Day04Test do
  use ExUnit.Case, async: true

  @input """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  test "part_one success" do
    assert 2 == AOC2022.Day04.part_one(@input)
  end

  test "part_two success" do
    assert 4 == AOC2022.Day04.part_two(@input)
  end
end
