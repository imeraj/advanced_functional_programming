defmodule FunParkTest do
  use ExUnit.Case
  doctest FunPark

  test "greets the world" do
    assert FunPark.hello() == :world
  end
end
