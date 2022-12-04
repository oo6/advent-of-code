defmodule AOC2022.Day03Test do
  use ExUnit.Case, async: true

  @input """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  test "part_one success" do
    assert 157 == AOC2022.Day03.part_one(@input)
  end

  test "part_two success" do
    assert 70 == AOC2022.Day03.part_two(@input)
  end
end
