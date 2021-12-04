defmodule AOC2021.Day02 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    {:ok, tokens, _} = :lexer.string(String.to_charlist(input))
    {:ok, ast} = :parser.parse(tokens)

    {horizontal, depth} = eval(ast, {0, 0})
    horizontal * depth
  end

  def part_two(input) do
    {:ok, tokens, _} = :lexer.string(String.to_charlist(input))
    {:ok, ast} = :parser.parse(tokens)

    {horizontal, depth, _} = eval(ast, {0, 0, 0})
    horizontal * depth
  end

  defp eval(ast, state) when is_list(ast), do: Enum.reduce(ast, state, &eval/2)
  defp eval({{:move, :forward}, {:number, n}}, {h, d}), do: {h + n, d}
  defp eval({{:move, :forward}, {:number, n}}, {h, d, a}), do: {h + n, d + n * a, a}
  defp eval({{:move, :down}, {:number, n}}, {h, d}), do: {h, d + n}
  defp eval({{:move, :down}, {:number, n}}, {h, d, a}), do: {h, d, a + n}
  defp eval({{:move, :up}, {:number, n}}, {h, d}), do: {h, d - n}
  defp eval({{:move, :up}, {:number, n}}, {h, d, a}), do: {h, d, a - n}
end
