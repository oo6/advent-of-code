defmodule AOC2022.Day07Test do
  use ExUnit.Case, async: true

  @input """
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """

  test "part_one success" do
    assert 95437 == AOC2022.Day07.part_one(@input)
  end

  test "part_two success" do
    assert 24_933_642 == AOC2022.Day07.part_two(@input)
  end
end
