defmodule AOC2022.Day02Test do
  use ExUnit.Case, async: true

  @input """
  A Y
  B X
  C Z
  """

  test "part_one success" do
    assert 15 == AOC2022.Day02.part_one(@input)
  end

  test "part_two success" do
    assert 12 == AOC2022.Day02.part_two(@input)
  end
end
