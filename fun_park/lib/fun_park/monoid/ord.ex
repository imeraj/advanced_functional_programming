defmodule FunPark.Monoid.Ord do
  @moduledoc false

  defstruct lt?: &__MODULE__.default/2,
            le?: &__MODULE__.default/2,
            gt?: &__MODULE__.default/2,
            ge?: &__MODULE__.default/2

  def default(_, _), do: false
end

defimpl FunPark.Monoid, for: FunPark.Monoid.Ord do
  alias FunPark.Monoid.Ord

  def empty(_), do: %Ord{}

  def append(%Ord{} = ord1, %Ord{} = ord2) do
    %Ord{
      lt?: fn a, b ->
        cond do
          ord1.lt?.(a, b) -> true
          ord1.gt?.(a, b) -> false
          true -> ord2.lt?.(a, b)
        end
      end,
      le?: fn a, b ->
        cond do
          ord1.lt?.(a, b) -> true
          ord1.gt?.(a, b) -> false
          true -> ord2.le?.(a, b)
        end
      end,
      gt?: fn a, b ->
        cond do
          ord1.gt?.(a, b) -> true
          ord1.lt?.(a, b) -> false
          true -> ord2.gt?.(a, b)
        end
      end,
      ge?: fn a, b ->
        cond do
          ord1.gt?.(a, b) -> true
          ord1.lt?.(a, b) -> false
          true -> ord2.ge?.(a, b)
        end
      end
    }
  end

  def wrap(%Ord{}, ord) do
    ord = FunPark.Ord.Utils.to_ord_map(ord)

    %Ord{
      lt?: ord.lt?,
      gt?: ord.gt?,
      le?: ord.le?,
      ge?: ord.ge?
    }
  end

  def unwrap(%Ord{
        lt?: lt?,
        gt?: gt?,
        le?: le?,
        ge?: ge?
      }) do
    %{
      lt?: lt?,
      gt?: gt?,
      le?: le?,
      ge?: ge?
    }
  end
end
