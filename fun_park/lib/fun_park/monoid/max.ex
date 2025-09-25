defmodule FunPark.Monoid.Max do
  defstruct value: nil, ord: FunPark.Ord
end

defimpl FunPark.Monoid, for: FunPark.Monoid.Max do
  alias FunPark.Monoid.Max
  alias FunPark.Ord.Utils

  def empty(%Max{value: min_value, ord: ord}), do: %Max{value: min_value, ord: ord}

  def append(%Max{value: a, ord: ord}, %Max{value: b}) do
    %Max{value: Utils.max(a, b, ord), ord: ord}
  end

  def wrap(%Max{ord: ord}, value) do
    %Max{value: value, ord: Utils.to_ord_map(ord)}
  end

  def unwrap(%Max{value: value}) do
    value
  end
end
