defmodule ChronalCharge do
  def run() do
    input = 6392

    grid =
      for x <- 1..300, y <- 1..300, into: %{} do
        id = x + 10
        count = (((id * y + input) * id / 100) |> trunc() |> rem(10)) - 5

        {{x, y}, count}
      end

    grid |> part_one() |> IO.inspect()
  end

  def part_one(grid) do
    {{l, t}, _} =
      for l <- 1..298, t <- 1..298 do
        sum =
          for x <- l..(l + 2), y <- t..(t + 2) do
            grid[{x, y}]
          end
          |> Enum.sum()

        {{l, t}, sum}
      end
      |> Enum.max_by(&elem(&1, 1))

    "#{l},#{t}"
  end
end

ChronalCharge.run()
