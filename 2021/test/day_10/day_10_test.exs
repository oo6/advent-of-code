defmodule AOC2021.Day10Test do
  use ExUnit.Case, async: true

  @input """
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
  """

  test "part_one success" do
    assert 26397 == AOC2021.Day10.part_one(@input)
  end

  test "part_two success" do
    assert 288_957 == AOC2021.Day10.part_two(@input)
  end
end
