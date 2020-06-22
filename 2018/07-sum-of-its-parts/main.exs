defmodule SumOfItsParts do
  def run do
    steps =
      "input.txt"
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(
        &String.split(&1, ["Step ", " must be finished before step ", " can begin."], trim: true)
      )
      |> Enum.reduce(%{}, fn [prev, next], acc ->
        acc
        |> Map.update(next, [prev], &[prev | &1])
        |> Map.put_new(prev, [])
      end)
      |> Enum.into([])

    steps |> part_one() |> IO.inspect()
    steps |> part_two() |> IO.inspect()
  end

  def part_one(steps) do
    order(steps)
  end

  def part_two(steps) do
    execute(steps)
  end

  def order(steps, order \\ "")

  def order([], order), do: order

  def order(steps, order) do
    [{curr, _} | _] =
      steps
      |> Enum.filter(fn {_, prev} -> prev == [] end)
      |> Enum.sort()

    steps
    |> Enum.map(fn {next, prev} -> {next, Enum.reject(prev, &(&1 == curr))} end)
    |> Enum.reject(fn {next, _} -> next == curr end)
    |> order(order <> curr)
  end

  def execute(steps, order \\ [], workers \\ [nil, nil, nil, nil, nil], seconds \\ 0)

  def execute([], [], [nil, nil, nil, nil, nil], seconds), do: seconds

  def execute(steps, order, workers, seconds) do
    nexts =
      steps
      |> Enum.filter(fn {_, prev} -> prev == [] end)
      |> Enum.sort()
      |> Enum.map(fn {next, _} -> next end)

    order = order ++ nexts

    {workers, order} =
      Enum.map_reduce(workers, order, fn
        nil, [] ->
          {nil, []}

        nil, [head | tail] ->
          s = :binary.first(head) - 4
          {{head, seconds + s}, tail}

        worker, acc ->
          {worker, acc}
      end)

    seconds = seconds + 1

    {workers, prevs} =
      Enum.map_reduce(workers, [], fn
        nil, [] -> {nil, []}
        {prev, ^seconds}, acc -> {nil, [prev, acc]}
        worker, acc -> {worker, acc}
      end)

    steps =
      steps
      |> Enum.map(fn {next, prev} -> {next, Enum.reject(prev, &(&1 in prevs))} end)
      |> Enum.reject(fn {next, _} -> next in nexts end)

    execute(steps, order, workers, seconds)
  end
end

SumOfItsParts.run()
