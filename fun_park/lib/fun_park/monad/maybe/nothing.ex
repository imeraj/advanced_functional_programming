defmodule FunPark.Monad.Maybe.Nothing do
  defstruct []

  def pure, do: %__MODULE__{}
end

defimpl FunPark.Foldable, for: FunPark.Monad.Maybe.Nothing do
  alias FunPark.Monad.Maybe.Nothing

  def fold_l(%Nothing{}, _just_fn, nothing_fn), do: nothing_fn.()
  def fold_r(nothing, just_fn, nothing_fn), do: fold_l(nothing, just_fn, nothing_fn)
end
