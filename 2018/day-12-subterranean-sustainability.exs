defmodule SubterraneanSustainability do
  def run do
    initial_state =
      String.split(
        "##.#..#.#..#.####.#########.#...#.#.#......##.#.#...##.....#...#...#.##.#...##...#.####.##..#.#..#.",
        "",
        trim: true
      )

    rules =
      "..#.. => .
..#.# => .
#.#.. => .
.#..# => .
#.... => .
....# => .
.#.#. => #
#.### => .
####. => .
..... => .
.#... => #
##### => #
.#### => .
#..#. => #
#...# => #
.###. => .
###.# => #
...## => #
#.##. => #
.#.## => #
##.#. => #
...#. => .
..### => #
###.. => #
##... => .
..##. => .
.##.# => .
##.## => .
.##.. => .
##..# => #
#.#.# => .
#..## => #"
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [k, v] = String.split(line, " => ")
        {String.split(k, "", trim: true), v}
      end)
      |> Enum.into(%{})

    initial_state |> part_one(rules) |> IO.inspect()
    initial_state |> part_two(rules) |> IO.inspect()
  end

  def part_one(state, rules) do
    {state, index} = generate(state, rules, 20)

    state
    |> Enum.with_index(index)
    |> Enum.reduce(0, fn
      {"#", i}, acc -> acc + i
      _, acc -> acc
    end)
  end

  def part_two(state, rules) do
    {state, index} = generate(state, rules, 50_000)

    sum =
      state
      |> Enum.with_index(index)
      |> Enum.reduce(0, fn
        {"#", i}, acc -> acc + i
        _, acc -> acc
      end)

    div(sum, 1000) * 1_000_000_000 + rem(sum, 1000)
  end

  def generate(state, rules, count, index \\ 0)

  def generate(state, _, 0, index) do
    {state, index}
  end

  def generate(state, rules, count, index) do
    {state, index} = padding(state, index)

    state
    |> Enum.chunk_every(5, 1, :discard)
    |> Enum.map(fn chunk ->
      case rules[chunk] do
        nil -> "."
        value -> value
      end
    end)
    |> List.flatten()
    |> generate(rules, count - 1, index + 2)
  end

  def padding(state, index) do
    state = Enum.join(state, "")
    tmp_state = String.replace(state, ~r/^(\.)*/, "....")

    offset =
      state
      |> String.myers_difference(tmp_state)
      |> Keyword.get(:ins, "")
      |> String.length()

    state =
      tmp_state
      |> String.replace(~r/(\.)*$/, "....", global: false)
      |> String.split("", trim: true)

    {state, index - offset}
  end
end

SubterraneanSustainability.run()
