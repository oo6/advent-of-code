defmodule AOC2021.Day21Test do
  use ExUnit.Case, async: true

  test "part_one success" do
    assert 739_785 == AOC2021.Day21.part_one(4, 8)
  end
end
