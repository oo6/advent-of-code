defmodule AOC2021.Day10 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn line, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.reduce_while([], &operate/2)
      |> case do
        char when is_binary(char) -> acc + point(char)
        _ -> acc
      end
    end)
  end

  def part_two(input) do
    scores =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce([], fn line, acc ->
        line
        |> String.split("", trim: true)
        |> Enum.reduce_while([], &operate/2)
        |> case do
          stack when is_list(stack) ->
            score = Enum.reduce(stack, 0, &(&2 * 5 + point(&1)))
            [score | acc]

          _ ->
            acc
        end
      end)
      |> Enum.sort()

    Enum.at(scores, floor(length(scores) / 2))
  end

  defp operate(char, stack) when char in ["(", "[", "{", "<"], do: {:cont, [char | stack]}
  defp operate(")", ["(" | tail]), do: {:cont, tail}
  defp operate("]", ["[" | tail]), do: {:cont, tail}
  defp operate("}", ["{" | tail]), do: {:cont, tail}
  defp operate(">", ["<" | tail]), do: {:cont, tail}
  defp operate(char, _stack), do: {:halt, char}

  defp point(")"), do: 3
  defp point("]"), do: 57
  defp point("}"), do: 1197
  defp point(">"), do: 25137
  defp point("("), do: 1
  defp point("["), do: 2
  defp point("{"), do: 3
  defp point("<"), do: 4
end
