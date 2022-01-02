defmodule AOC2021.Day18 do
  def run() do
    input = "input.txt" |> Path.expand(__DIR__) |> File.read!()

    input |> part_one() |> IO.inspect()
    input |> part_two() |> IO.inspect()
  end

  def part_one(input) do
    [head | tail] =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))

    Enum.reduce(tail, head, fn list, acc ->
      [acc, list]
      |> to_tree({nil, "root", 0})
      |> explode()
      |> to_list()
    end)
    |> magnitude()
  end

  def part_two(input) do
    list =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))

    for left <- list, right <- list, left != right do
      Enum.map(
        [[left, right], [right, left]],
        &Task.async(fn ->
          &1 |> to_tree({nil, "root", 0}) |> explode() |> to_list() |> magnitude()
        end)
      )
    end
    |> List.flatten()
    |> Task.await_many()
    |> Enum.max()
  end

  defp explode(tree) do
    new_tree =
      case find_explode_key(tree) do
        nil -> tree
        key -> do_explode(tree, key)
      end

    if tree != new_tree, do: explode(new_tree), else: split(tree)
  end

  defp find_explode_key(tree, key \\ "root", depth \\ 0) do
    if is_list(tree[key].value) do
      if depth == 4 do
        key
      else
        Enum.find_value(tree[key].value, &find_explode_key(tree, &1, depth + 1))
      end
    end
  end

  defp do_explode(tree, key) do
    %{value: [left_key, right_key], index: index, parent: parent} = tree[key]
    values = %{left: tree[left_key].value, right: tree[right_key].value}

    [:left, :right]
    |> Enum.reduce(tree, fn type, acc ->
      case find_number_key(type, key, tree) do
        nil -> acc
        key -> Map.update!(acc, key, &Map.put(&1, :value, &1.value + values[type]))
      end
    end)
    |> Map.put(key, %{value: 0, index: index, parent: parent})
  end

  defp find_number_key(type, key, tree) do
    %{parent: parent, index: index} = tree[key]

    if parent do
      if index == if(type == :left, do: 1, else: 0) do
        tree[parent].value
        |> Enum.at(if type == :left, do: 0, else: 1)
        |> find_child_key(tree, index)
      else
        find_number_key(type, tree[key].parent, tree)
      end
    end
  end

  defp find_child_key(key, tree, index) do
    if is_list(tree[key].value) do
      tree[key].value |> Enum.at(index) |> find_child_key(tree, index)
    else
      key
    end
  end

  defp split(tree) do
    new_tree =
      case find_split_key(tree) do
        nil -> tree
        key -> do_split(tree, key)
      end

    if tree != new_tree, do: explode(new_tree), else: tree
  end

  defp find_split_key(tree, key \\ "root") do
    if is_list(tree[key].value) do
      Enum.find_value(tree[key].value, &find_split_key(tree, &1))
    else
      if tree[key].value >= 10 do
        key
      end
    end
  end

  defp do_split(tree, key) do
    %{value: item, index: index, parent: parent} = tree[key]
    left_key = unique_key()
    right_key = unique_key()

    Map.merge(tree, %{
      left_key => %{parent: key, index: 0, value: floor(item / 2)},
      right_key => %{parent: key, index: 1, value: ceil(item / 2)},
      key => %{parent: parent, index: index, value: [left_key, right_key]}
    })
  end

  defp to_tree(list, tree \\ %{}, {parent, self, index}) do
    list = Enum.with_index(list, &{unique_key(), &1, &2})

    list
    |> Enum.reduce(tree, fn
      {key, value, index}, acc when is_number(value) ->
        Map.put(acc, key, %{parent: self, index: index, value: value})

      {key, value, index}, acc ->
        to_tree(value, acc, {self, key, index})
    end)
    |> Map.put(self, %{parent: parent, index: index, value: Enum.map(list, &elem(&1, 0))})
  end

  defp to_list(tree, key \\ "root") do
    if is_list(tree[key].value) do
      Enum.map(tree[key].value, &to_list(tree, &1))
    else
      tree[key].value
    end
  end

  defp magnitude(term) when is_number(term), do: term
  defp magnitude([left, right]), do: 3 * magnitude(left) + 2 * magnitude(right)

  defp unique_key(), do: System.unique_integer([:positive])
end
