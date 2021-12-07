defmodule AOC2021.Day01Test do
  use ExUnit.Case, async: true

  @input """
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
  """

  test "part_one success" do
    assert 7 == AOC2021.Day01.part_one(@input)
  end

  test "part_two success" do
    assert 5 == AOC2021.Day01.part_two(@input)
  end
end
