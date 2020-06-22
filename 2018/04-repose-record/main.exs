defmodule ReposeRecord do
  def run() do
    logs =
      "input.txt"
      |> File.read!()
      |> String.split("\n")
      |> Enum.sort()
      |> Enum.map(&parse/1)
      |> Enum.reduce(%{"id" => nil, "start" => 0}, &group_by_id(&2, &1))
      |> Map.delete("id")
      |> Map.delete("start")
      |> Enum.into([])

    logs |> part_one() |> IO.inspect()
    logs |> part_two() |> IO.inspect()
  end

  def part_one(logs) do
    {id, stat} =
      Enum.max_by(logs, &Enum.reduce(elem(&1, 1), 0, fn {_, count}, acc -> acc + count end))

    {minute, _} = find_minute_of_max_count(stat)

    id * minute
  end

  def part_two(logs) do
    {id, minute, _} =
      Enum.reduce(logs, {0, 0, 0}, fn {id, stat}, {_, _, count} = acc ->
        {minute, c} = find_minute_of_max_count(stat)

        if c > count, do: {id, minute, c}, else: acc
      end)

    id * minute
  end

  defp parse(line) do
    [_, minute, event] = String.split(line, [":", "] "], trim: true)
    minute = String.to_integer(minute)

    if String.starts_with?(event, "Guard") do
      [_, id | _] = String.split(event, [" #", " "])

      %{minute: minute, event: String.to_integer(id)}
    else
      %{minute: minute, event: event}
    end
  end

  defp group_by_id(logs, %{event: "falls asleep", minute: start}),
    do: Map.put(logs, "start", start)

  defp group_by_id(logs, %{event: "wakes up", minute: minute}) do
    item = {logs["start"], minute - logs["start"]}
    Map.update(logs, logs["id"], [item], &[item | &1])
  end

  defp group_by_id(logs, %{event: id}), do: Map.put(logs, "id", id)

  defp find_minute_of_max_count(stat) do
    0..59
    |> Enum.map(
      &{&1, Enum.count(stat, fn {start, count} -> &1 >= start && &1 <= start + count - 1 end)}
    )
    |> Enum.max_by(&elem(&1, 1))
  end
end

ReposeRecord.run()
