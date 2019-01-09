defmodule MemoryManeuver do
  def run do
    {root, _} =
      "day-08-input.txt"
      |> File.read!()
      |> String.replace_suffix("\n", "")
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
      |> parse()

    root |> part_one() |> IO.inspect()
    root |> part_two() |> IO.inspect()
  end

  def part_one(root) do
    count(root, :value)
  end

  def part_two(root) do
    count(root, :index)
  end

  def count(nil, _), do: 0

  def count(%{nodes: [], metadata: metadata}, _), do: Enum.sum(metadata)

  def count(%{nodes: nodes, metadata: metadata}, :value) do
    nodes
    |> Enum.map(&count(&1, :value))
    |> Enum.concat(metadata)
    |> Enum.sum()
  end

  def count(%{nodes: nodes, metadata: metadata}, :index) do
    metadata
    |> Enum.map(&(nodes |> Enum.at(&1 - 1) |> count(:index)))
    |> Enum.sum()
  end

  def parse([0, metadata_count | tail]) do
    {metadata, tail} = Enum.split(tail, metadata_count)

    {%{metadata: metadata, nodes: []}, tail}
  end

  def parse([nodes_count, metadata_count | tail]) do
    {nodes, tail} = Enum.map_reduce(1..nodes_count, tail, fn _, acc -> parse(acc) end)
    {metadata, tail} = Enum.split(tail, metadata_count)

    {%{metadata: metadata, nodes: nodes}, tail}
  end
end

MemoryManeuver.run()
