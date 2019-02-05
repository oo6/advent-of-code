defmodule ChocolateCharts do
  def run do
    input = "846601"

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    input |> String.to_integer() |> iterate_until_after(%{0 => 3, 1 => 7}, [0, 1])
  end

  def part_two(input) do
    iterate_until_match(input, %{0 => 3, 1 => 7}, [0, 1], "0000037")
  end

  defp iterate_until_after(input, recipes, _) when map_size(recipes) > input + 10 do
    0..9 |> Enum.map(&recipes[input + &1]) |> Enum.join()
  end

  defp iterate_until_after(input, recipes, elves) do
    {recipes, elves, _} = iterate(recipes, elves)
    iterate_until_after(input, recipes, elves)
  end

  defp iterate_until_match(input, recipes, _, <<_::bytes-size(1), input::binary>>) do
    map_size(recipes) - String.length(input)
  end

  defp iterate_until_match(input, recipes, _, <<input::bytes-size(6), _::binary>>) do
    map_size(recipes) - String.length(input) - 1
  end

  defp iterate_until_match(input, recipes, elves, suffix) do
    {recipes, elves, new_recipes} = iterate(recipes, elves)
    suffix = String.slice(suffix, length(new_recipes)..-1) <> Enum.join(new_recipes)
    iterate_until_match(input, recipes, elves, suffix)
  end

  defp iterate(recipes, elves) do
    new_recipes =
      elves
      |> Enum.map(&recipes[&1])
      |> Enum.sum()
      |> Integer.digits()

    recipes =
      new_recipes
      |> Enum.with_index(map_size(recipes))
      |> Enum.reduce(recipes, fn {v, k}, acc -> Map.put(acc, k, v) end)

    elves = Enum.map(elves, &rem(recipes[&1] + 1 + &1, map_size(recipes)))

    {recipes, elves, new_recipes}
  end
end

ChocolateCharts.run()
