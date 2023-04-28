defmodule SorobanTest do
  use ExUnit.Case
  doctest Soroban

  test "greets the world" do
    assert Soroban.hello() == :world
  end
end
