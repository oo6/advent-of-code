defmodule AOC2021.Day03Test do
  use ExUnit.Case, async: true

  @input """
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
  """

  test "part_one success" do
    assert 198 == AOC2021.Day03.part_one(@input)
  end

  test "part_two success" do
    assert 230 == AOC2021.Day03.part_two(@input)
  end
end
