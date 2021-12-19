defmodule AOC2021.Day16Test do
  use ExUnit.Case, async: true

  @inputs_one [
    "8A004A801A8002F478",
    "620080001611562C8802118E34",
    "C0015000016115A2E0802F182340",
    "A0016C880162017C3686B18A3D4780"
  ]

  @inputs_two [
    "C200B40A82",
    "04005AC33890",
    "880086C3E88112",
    "CE00C43D881120",
    "D8005AC2A8F0",
    "F600BC2D8F",
    "9C005AC2F8F0",
    "9C0141080250320F1802104A08"
  ]

  test "part_one success" do
    assert 16 == @inputs_one |> Enum.at(0) |> AOC2021.Day16.part_one()
    assert 12 == @inputs_one |> Enum.at(1) |> AOC2021.Day16.part_one()
    assert 23 == @inputs_one |> Enum.at(2) |> AOC2021.Day16.part_one()
    assert 31 == @inputs_one |> Enum.at(3) |> AOC2021.Day16.part_one()
  end

  test "part_two success" do
    assert 3 == @inputs_two |> Enum.at(0) |> AOC2021.Day16.part_two()
    assert 54 == @inputs_two |> Enum.at(1) |> AOC2021.Day16.part_two()
    assert 7 == @inputs_two |> Enum.at(2) |> AOC2021.Day16.part_two()
    assert 9 == @inputs_two |> Enum.at(3) |> AOC2021.Day16.part_two()
    assert 1 == @inputs_two |> Enum.at(4) |> AOC2021.Day16.part_two()
    assert 0 == @inputs_two |> Enum.at(5) |> AOC2021.Day16.part_two()
    assert 0 == @inputs_two |> Enum.at(6) |> AOC2021.Day16.part_two()
    assert 1 == @inputs_two |> Enum.at(7) |> AOC2021.Day16.part_two()
  end
end
