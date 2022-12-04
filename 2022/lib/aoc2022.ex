defmodule AOC2022 do
  @moduledoc """
  Documentation for `AOC2022`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AOC2022.hello()
      :world

  """
  def hello do
    :world
  end

  defmacro __using__(_opts) do
    quote do
      def run do
        input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

        input |> part_one() |> IO.inspect()
        input |> part_two() |> IO.inspect()
      end

      def part_one(_input), do: :no_implementation
      def part_two(_input), do: :no_implementation

      defoverridable part_one: 1, part_two: 1
    end
  end
end
