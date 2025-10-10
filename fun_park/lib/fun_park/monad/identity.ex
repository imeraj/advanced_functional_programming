defmodule FunPark.Monad.Identity do
  alias FunPark.Eq
  alias FunPark.Ord

  @enforce_keys [:value]
  defstruct [:value]

  def pure(value), do: %__MODULE__{value: value}
  def extract(%__MODULE__{value: value}), do: value

  def lift_eq(custom_eq) do
    custom_eq = Eq.Utils.to_eq_map(custom_eq)

    %{
      eq?: fn %__MODULE__{value: a}, %__MODULE__{value: b} -> custom_eq.eq?.(a, b) end,
      not_eq?: fn %__MODULE__{value: a}, %__MODULE__{value: b} -> custom_eq.not_eq?.(a, b) end
    }
  end

  def lift_ord(custom_ord) do
    custom_ord = Ord.Utils.to_ord_map(custom_ord)

    %{
      lt?: fn %__MODULE__{value: a}, %__MODULE__{value: b} -> custom_ord.lt?.(a, b) end,
      le?: fn %__MODULE__{value: a}, %__MODULE__{value: b} -> custom_ord.le?.(a, b) end,
      gt?: fn %__MODULE__{value: a}, %__MODULE__{value: b} -> custom_ord.gt?.(a, b) end,
      ge?: fn %__MODULE__{value: a}, %__MODULE__{value: b} -> custom_ord.ge?.(a, b) end
    }
  end
end

defimpl FunPark.Eq, for: FunPark.Monad.Identity do
  alias FunPark.Monad.Identity
  alias FunPark.Eq

  def eq?(%Identity{value: v1}, %Identity{value: v2}), do: Eq.eq?(v1, v2)
  def not_eq?(%Identity{value: v1}, %Identity{value: v2}), do: Eq.not_eq?(v1, v2)
end

defimpl FunPark.Ord, for: FunPark.Monad.Identity do
  alias FunPark.Monad.Identity
  alias FunPark.Ord

  def lt?(%Identity{value: v1}, %Identity{value: v2}), do: Ord.lt?(v1, v2)
  def le?(%Identity{value: v1}, %Identity{value: v2}), do: Ord.le?(v1, v2)
  def gt?(%Identity{value: v1}, %Identity{value: v2}), do: Ord.gt?(v1, v2)
  def ge?(%Identity{value: v1}, %Identity{value: v2}), do: Ord.ge?(v1, v2)
end

defimpl FunPark.Monad, for: FunPark.Monad.Identity do
  alias FunPark.Monad.Identity

  def map(%Identity{value: value}, func) do
    Identity.pure(func.(value))
  end

  def bind(%Identity{value: value}, func) do
    func.(value)
  end

  def ap(%Identity{value: func}, %Identity{value: value}) do
    Identity.pure(func.(value))
  end
end
