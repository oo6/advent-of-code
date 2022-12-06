defmodule AOC2022.Day06Test do
  use ExUnit.Case, async: true

  test "part_one success" do
    assert 7 = AOC2022.Day06.part_one("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
    assert 5 = AOC2022.Day06.part_one("bvwbjplbgvbhsrlpgdmjqwftvncz")
    assert 6 = AOC2022.Day06.part_one("nppdvjthqldpwncqszvftbrmjlhg")
    assert 10 = AOC2022.Day06.part_one("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
    assert 11 = AOC2022.Day06.part_one("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  end

  test "part_two success" do
    assert 19 = AOC2022.Day06.part_two("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
    assert 23 = AOC2022.Day06.part_two("bvwbjplbgvbhsrlpgdmjqwftvncz")
    assert 23 = AOC2022.Day06.part_two("nppdvjthqldpwncqszvftbrmjlhg")
    assert 29 = AOC2022.Day06.part_two("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
    assert 26 = AOC2022.Day06.part_two("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  end
end
