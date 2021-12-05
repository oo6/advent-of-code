defmodule AOC2021.Day04 do
  def run() do
    numbers = "numbers.txt" |> Path.expand(__DIR__) |> File.read!() |> String.replace("\n", "")
    boards = "boards.txt" |> Path.expand(__DIR__) |> File.read!()

    numbers |> part_one(boards) |> IO.inspect()
    numbers |> part_two(boards) |> IO.inspect()
  end

  def part_one(numbers, boards) do
    boards = init_boards(boards)

    {number, board} =
      numbers
      |> String.split(",", trim: true)
      |> Enum.reduce_while(boards, fn number, boards ->
        boards = boards |> draw(number) |> win()

        case Enum.find(boards, & &1.win) do
          nil -> {:cont, boards}
          board -> {:halt, {number, board}}
        end
      end)

    score(number, board)
  end

  def part_two(numbers, boards) do
    boards = init_boards(boards)

    {number, board, _} =
      numbers
      |> String.split(",", trim: true)
      |> Enum.reduce({nil, nil, boards}, fn number, {win_number, win_board, boards} ->
        boards = boards |> draw(number) |> win()
        {win_boards, boards} = Enum.split_with(boards, & &1.win)

        if length(win_boards) > 0 do
          {number, List.last(win_boards), boards}
        else
          {win_number, win_board, boards}
        end
      end)

    score(number, board)
  end

  defp draw(boards, number) do
    Enum.map(boards, fn
      %{numbers: numbers} = board when is_map_key(numbers, number) ->
        %{board | drawn: Map.put(board.drawn, numbers[number], true)}

      board ->
        board
    end)
  end

  defp win(boards) do
    Enum.map(
      boards,
      fn board ->
        win =
          Enum.any?(0..4, fn row -> Enum.all?(0..4, &board.drawn[{row, &1}]) end) ||
            Enum.any?(0..4, fn col -> Enum.all?(0..4, &board.drawn[{&1, col}]) end)

        if win, do: %{board | win: true}, else: board
      end
    )
  end

  defp score(number, board) do
    unmarked =
      Enum.reduce(board.numbers, 0, fn {key, value}, acc ->
        if board.drawn[value], do: acc, else: acc + String.to_integer(key)
      end)

    String.to_integer(number) * unmarked
  end

  defp init_boards(boards) do
    boards
    |> String.split("\n", trim: true)
    |> Enum.chunk_every(5, 5)
    |> Enum.map(fn board ->
      numbers =
        board
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {line, row}, out_acc ->
          line
          |> String.split(" ", trim: true)
          |> Enum.with_index()
          |> Enum.reduce(out_acc, fn {number, col}, in_acc ->
            Map.put(in_acc, number, {row, col})
          end)
        end)

      %{numbers: numbers, drawn: %{}, win: false}
    end)
  end
end
