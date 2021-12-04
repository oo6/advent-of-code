defmodule AOC2021Test do
  use ExUnit.Case, async: true
  doctest AOC2021

  test "greets the world" do
    assert AOC2021.hello() == :world
  end
end
