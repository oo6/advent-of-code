defmodule AOC2022.Day05Test do
  use ExUnit.Case, async: true

  @input """
      [D]
  [N] [C]
  [Z] [M] [P]
   1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  test "part_one success" do
    assert "CMZ" == AOC2022.Day05.part_one(@input)
  end

  test "part_two success" do
    assert "MCD" == AOC2022.Day05.part_two(@input)
  end
end
