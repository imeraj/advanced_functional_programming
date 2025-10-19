defmodule FunPark.Monad.Maybe.Just do
  @enforce_keys [:value]
  defstruct [:value]

  def pure(nil), do: raise(ArgumentError, "Cannot wrap nil in a Just")
  def pure(value), do: %__MODULE__{value: value}
end

defimpl FunPark.Foldable, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Monad.Maybe.Just

  def fold_l(%Just{value: value}, just_fn, _nothing_fn), do: just_fn.(value)
  def fold_r(just, just_fn, nothing_fn), do: fold_l(just, just_fn, nothing_fn)
end

defimpl FunPark.Eq, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Eq
  alias FunPark.Monad.Maybe.Just
  alias FunPark.Monad.Maybe.Nothing

  def eq?(%Just{value: v1}, %Just{value: v2}), do: Eq.eq?(v1, v2)
  def eq?(%Just{}, %Nothing{}), do: false

  def not_eq?(%Just{value: v1}, %Just{value: v2}), do: not Eq.eq?(v1, v2)
  def not_eq?(%Just{}, %Nothing{}), do: true
end
