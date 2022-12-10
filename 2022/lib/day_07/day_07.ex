defmodule AOC2022.Day07 do
  use AOC2022

  def part_one(input) do
    filesystem = parse_filesystem(input)

    filesystem
    |> Enum.map(&(&1 |> elem(0) |> calc_total_size(filesystem)))
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def part_two(input) do
    filesystem = parse_filesystem(input)

    total_sizes = Enum.map(filesystem, &(&1 |> elem(0) |> calc_total_size(filesystem)))
    least_delete_size = 30_000_000 - (70_000_000 - Enum.max(total_sizes))

    total_sizes
    |> Enum.sort()
    |> Enum.find(&(&1 >= least_delete_size))
  end

  def calc_total_size(dir, filesystem, total_size \\ 0) do
    Enum.reduce(filesystem[dir], total_size, fn
      {_file, size}, acc -> acc + size
      sub_dir, acc -> calc_total_size(sub_dir, filesystem, acc)
    end)
  end

  def parse_filesystem(input) do
    {_curr, filesystem} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({"/", %{}}, fn
        "$ cd " <> dir, {curr, filesystem} ->
          {Path.join(curr, dir), filesystem}

        "$ cd ..", {curr, filesystem} ->
          {Path.dirname(curr), filesystem}

        "$ ls", {curr, filesystem} ->
          {curr, Map.put(filesystem, curr, [])}

        "dir " <> dir, {curr, filesystem} ->
          {curr, Map.update(filesystem, curr, &[Path.join(curr, dir) | &1])}

        size_and_file, {curr, filesystem} ->
          [size, file] = String.split(size_and_file, " ")
          filesystem = Map.update(filesystem, curr, &[{file, String.to_integer(size)} | &1])

          {curr, filesystem}
      end)

    filesystem
  end
end
