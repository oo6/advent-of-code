defmodule AOC2021.Day06Test do
  use ExUnit.Case, async: true

  @input "3,4,3,1,2"

  test "part_one success" do
    assert 5934 == AOC2021.Day06.part_one(@input)
  end

  test "part_two success" do
    assert 26_984_457_539 == AOC2021.Day06.part_two(@input)
  end
end
