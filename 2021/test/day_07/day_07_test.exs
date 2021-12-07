defmodule AOC2021.Day07Test do
  use ExUnit.Case, async: true

  @input "16,1,2,0,4,2,7,1,2,14"

  test "part_one success" do
    assert 37 == AOC2021.Day07.part_one(@input)
  end

  test "part_two success" do
    assert 168 == AOC2021.Day07.part_two(@input)
  end
end
