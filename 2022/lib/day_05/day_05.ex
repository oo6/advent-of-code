defmodule AOC2022.Day05 do
  use AOC2022

  def part_one(input) do
    {stacks, steps} = parse_stacks_and_steps(input)

    Enum.reduce(steps, stacks, fn [count, from, to], out_acc ->
      Enum.reduce(1..count, out_acc, fn _, in_acc ->
        [crate | tail] = in_acc[from]
        Map.merge(in_acc, %{from => tail, to => [crate | in_acc[to]]})
      end)
    end)
    |> Enum.map(&(&1 |> elem(1) |> hd()))
    |> Enum.join()
  end

  def part_two(input) do
    {stacks, steps} = parse_stacks_and_steps(input)

    Enum.reduce(steps, stacks, fn [count, from, to], acc ->
      Map.merge(acc, %{
        from => Enum.drop(acc[from], count),
        to => Enum.slice(acc[from], 0..(count - 1)) ++ acc[to]
      })
    end)
    |> Enum.map(&(&1 |> elem(1) |> hd()))
    |> Enum.join()
  end

  def parse_stacks_and_steps(input) do
    {stacks, [stack_names | steps]} =
      input
      |> String.split("\n", trim: true)
      |> Enum.split_while(&(!String.starts_with?(&1, " 1")))

    stack_names =
      stack_names
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reject(&(elem(&1, 0) == " "))

    # %{"1" => ["N", "Z"], "2" => ["D", "C", "M"], "3" => ["P"]}
    stacks =
      stacks
      |> Enum.reduce(%{}, fn line, out_acc ->
        Enum.reduce(stack_names, out_acc, fn {name, index}, in_acc ->
          case String.at(line, index) do
            " " -> in_acc
            nil -> in_acc
            crate -> Map.update(in_acc, name, [crate], &[crate | &1])
          end
        end)
      end)
      |> Map.new(&{elem(&1, 0), &1 |> elem(1) |> Enum.reverse()})

    steps =
      Enum.map(steps, fn step ->
        [_, count, from, to] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, step)
        [String.to_integer(count), from, to]
      end)

    {stacks, steps}
  end
end
