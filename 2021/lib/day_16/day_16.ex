defmodule AOC2021.Day16 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    packets =
      input
      |> String.split("", trim: true)
      |> Enum.map(fn char ->
        char |> String.to_integer(16) |> Integer.to_string(2) |> String.pad_leading(4, "0")
      end)
      |> Enum.join()

    {_, messages} = decode(packets)
    sum(messages)
  end

  def part_two(input) do
    packets =
      input
      |> String.split("", trim: true)
      |> Enum.map(fn char ->
        char |> String.to_integer(16) |> Integer.to_string(2) |> String.pad_leading(4, "0")
      end)
      |> Enum.join()

    {_, messages} = decode(packets)
    calculate(messages)
  end

  defp decode(<<version::bytes-size(3)>> <> tail) do
    {tail, {version}} |> decode()
  end

  defp decode({<<type::bytes-size(3)>> <> tail, {version}}) do
    {tail, {version, type}} |> decode()
  end

  defp decode({"0" <> <<number::bytes-size(4)>> <> tail, {version, "100"}}) do
    {tail, {version, "100", number}}
  end

  defp decode({"0" <> <<number::bytes-size(4)>> <> tail, {version, "100", number_high}}) do
    {tail, {version, "100", number_high <> number}}
  end

  defp decode({"1" <> <<number::bytes-size(4)>> <> tail, {version, "100"}}) do
    {tail, {version, "100", number}} |> decode()
  end

  defp decode({"1" <> <<number::bytes-size(4)>> <> tail, {version, "100", number_high}}) do
    {tail, {version, "100", number_high <> number}} |> decode()
  end

  defp decode({"0" <> <<length::bytes-size(15)>> <> tail, {version, type}}) do
    length = String.to_integer(length, 2)
    {packets, tail} = String.split_at(tail, length)

    messages =
      Enum.reduce_while(1..floor(length / 11 + 1), {packets, []}, fn
        _, {"", messages} ->
          {:halt, Enum.reverse(messages)}

        _, {acc, messages} ->
          {acc, message} = decode(acc)
          {:cont, {acc, [message | messages]}}
      end)

    {tail, {version, type, messages}}
  end

  defp decode({"1" <> <<length::bytes-size(11)>> <> tail, {version, type}}) do
    length = String.to_integer(length, 2)

    {tail, messages} =
      Enum.reduce(1..length, {tail, []}, fn _, {acc, messages} ->
        {acc, message} = decode(acc)
        {acc, [message | messages]}
      end)

    {tail, {version, type, Enum.reverse(messages)}}
  end

  defp sum({version, "100", _number}) do
    String.to_integer(version, 2)
  end

  defp sum({version, _type, messages}) do
    String.to_integer(version, 2) + Enum.reduce(messages, 0, &(sum(&1) + &2))
  end

  defp calculate({_version, "000", messages}) do
    messages |> Enum.map(&calculate/1) |> Enum.sum()
  end

  defp calculate({_version, "001", messages}) do
    messages |> Enum.map(&calculate/1) |> Enum.product()
  end

  defp calculate({_version, "010", messages}) do
    messages |> Enum.map(&calculate/1) |> Enum.min()
  end

  defp calculate({_version, "011", messages}) do
    messages |> Enum.map(&calculate/1) |> Enum.max()
  end

  defp calculate({_version, "100", number}) do
    String.to_integer(number, 2)
  end

  defp calculate({_version, "101", [message_a, message_b]}) do
    if calculate(message_a) > calculate(message_b), do: 1, else: 0
  end

  defp calculate({_version, "110", [message_a, message_b]}) do
    if calculate(message_a) < calculate(message_b), do: 1, else: 0
  end

  defp calculate({_version, "111", [message_a, message_b]}) do
    if calculate(message_a) == calculate(message_b), do: 1, else: 0
  end
end
