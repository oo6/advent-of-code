defmodule AOC2021.Day02Test do
  use ExUnit.Case, async: true

  @input """
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
  """

  test "part_one success" do
    assert 150 == AOC2021.Day02.part_one(@input)
  end

  test "part_two success" do
    assert 900 == AOC2021.Day02.part_two(@input)
  end
end
