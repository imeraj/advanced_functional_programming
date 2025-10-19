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

defimpl FunPark.Ord, for: FunPark.Monad.Maybe.Just do
  alias FunPark.Ord
  alias FunPark.Monad.Maybe.Just
  alias FunPark.Monad.Maybe.Nothing

  def lt?(%Just{value: v1}, %Just{value: v2}), do: Ord.lt?(v1, v2)
  def lt?(%Just{}, %Nothing{}), do: false

  def le?(%Just{value: v1}, %Just{value: v2}), do: Ord.le?(v1, v2)
  def le?(%Just{}, %Nothing{}), do: false

  def gt?(%Just{value: v1}, %Just{value: v2}), do: Ord.gt?(v1, v2)
  def gt?(%Just{}, %Nothing{}), do: true

  def ge?(%Just{value: v1}, %Just{value: v2}), do: Ord.ge?(v1, v2)
  def ge?(%Just{}, %Nothing{}), do: true
end
