defmodule AlchemicalReduction do
  def run() do
    chars =
      "day-05-input.txt"
      |> File.read!()
      |> String.replace_suffix("\n", "")
      |> String.split("", trim: true)

    chars |> part_one() |> IO.inspect()
    chars |> part_two() |> IO.inspect()
  end

  def part_one(chars) do
    [] |> react(chars, false) |> length()
  end

  def part_two(chars) do
    "abcdefghigklmnopqrstuvwxyz"
    |> String.split("", trim: true)
    |> Enum.map(&(chars |> Enum.reject(fn c -> String.downcase(c) == &1 end) |> part_one()))
    |> Enum.min()
  end

  def react(head, [], false), do: Enum.reverse(head)

  def react(head, [], true), do: react([], Enum.reverse(head), false)

  def react(head, [char], reacted), do: react([char | head], [], reacted)

  def react(head, [a, b | tail], reacted) do
    upcase_a = String.upcase(a)
    upcase_b = String.upcase(b)

    if upcase_a == upcase_b && a != b do
      react(head, tail, true)
    else
      react([a | head], [b | tail], reacted)
    end
  end
end

AlchemicalReduction.run()
