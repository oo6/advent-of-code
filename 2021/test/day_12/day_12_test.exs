defmodule AOC2021.Day12Test do
  use ExUnit.Case, async: true

  @inputs [
    """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """,
    """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """,
    """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """
  ]

  test "part_one success" do
    assert 10 == @inputs |> Enum.at(0) |> AOC2021.Day12.part_one()
    assert 19 == @inputs |> Enum.at(1) |> AOC2021.Day12.part_one()
    assert 226 == @inputs |> Enum.at(2) |> AOC2021.Day12.part_one()
  end

  test "part_two success" do
    assert 36 == @inputs |> Enum.at(0) |> AOC2021.Day12.part_two()
    assert 103 == @inputs |> Enum.at(1) |> AOC2021.Day12.part_two()
    assert 3509 == @inputs |> Enum.at(2) |> AOC2021.Day12.part_two()
  end
end
