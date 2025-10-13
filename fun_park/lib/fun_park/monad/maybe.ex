defmodule FunPark.Monad.Maybe do
  import FunPark.Foldable, only: [fold_l: 3]

  alias FunPark.Monad.Maybe.Just
  alias FunPark.Monad.Maybe.Nothing

  defdelegate just(value), to: Just, as: :pure
  defdelegate nothing, to: Nothing, as: :pure
  def pure(value), do: just(value)

  def just?(%Just{}), do: true
  def just?(_), do: false

  def nothing?(%Nothing{}), do: true
  def nothing?(_), do: false

  def get_or_else(maybe, default), do: fold_l(maybe, & &1, fn -> default end)
end

defimpl FunPark.Foldable, for: FunPark.Monad.Maybe do
  alias FunPark.Monad.Maybe.Just
  alias FunPark.Monad.Maybe.Nothing

  def fold_l(%Just{value: value}, just_fn, _nothing_fn), do: just_fn.(value)
  def fold_l(%Nothing{}, _just_fn, nothing_fn), do: nothing_fn.()

  def fold_r(%Just{value: value}, just_fn, _nothing_fn), do: just_fn.(value)
  def fold_r(%Nothing{}, _just_fn, nothing_fn), do: nothing_fn.()
end
