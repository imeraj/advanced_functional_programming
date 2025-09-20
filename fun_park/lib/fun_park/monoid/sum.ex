defmodule FunPark.Monoid.Sum do
  defstruct value: 0
end

defimpl FunPark.Monoid, for: FunPark.Monoid.Sum do
  alias FunPark.Monoid.Sum

  def empty(_), do: %Sum{}
  def append(%Sum{value: a}, %Sum{value: b}), do: %Sum{value: a + b}
  def wrap(%Sum{}, value), do: %Sum{value: value}
  def unwrap(%Sum{value: value}), do: value
end
