defmodule AOC2022.Day01Test do
  use ExUnit.Case, async: true

  @input """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "part_one success" do
    assert 24000 == AOC2022.Day01.part_one(@input)
  end

  test "part_two success" do
    assert 45000 == AOC2022.Day01.part_two(@input)
  end
end
