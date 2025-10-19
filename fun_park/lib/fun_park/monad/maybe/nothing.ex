defmodule FunPark.Monad.Maybe.Nothing do
  defstruct []

  def pure, do: %__MODULE__{}
end

defimpl FunPark.Foldable, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Nothing

  def fold_l(%Nothing{}, _just_fn, nothing_fn), do: nothing_fn.()
  def fold_r(nothing, just_fn, nothing_fn), do: fold_l(nothing, just_fn, nothing_fn)
end

defimpl FunPark.Eq, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Just
  alias FunPark.Monad.Maybe.Nothing

  def eq?(%Nothing{}, %Nothing{}), do: true
  def eq?(%Nothing{}, %Just{}), do: false

  def not_eq?(%Nothing{}, %Nothing{}), do: false
  def not_eq?(%Nothing{}, %Just{}), do: true
end

defimpl FunPark.Ord, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Just
  alias FunPark.Monad.Maybe.Nothing

  def lt?(%Nothing{}, %Just{}), do: true
  def lt?(%Nothing{}, %Nothing{}), do: false

  def le?(%Nothing{}, %Just{}), do: true
  def le?(%Nothing{}, %Nothing{}), do: false

  def gt?(%Nothing{}, %Just{}), do: false
  def gt?(%Nothing{}, %Nothing{}), do: true

  def ge?(%Nothing{}, %Just{}), do: false
  def ge?(%Nothing{}, %Nothing{}), do: true
end
