defmodule FunPark.Ord.Utils do
  @moduledoc """
  Utility functions for working with ordered data.
  """
  import FunPark.Monoid.Utils

  alias FunPark.Ord
  alias FunPark.Monoid

  def append(a, b) do
    m_append(%Monoid.Ord{}, a, b)
  end

  def concat(ord_list) when is_list(ord_list) do
    m_concat(%Monoid.Ord{}, ord_list)
  end

  def to_eq(ord \\ Ord) do
    %{
      eq?: fn a, b -> compare(a, b, ord) == :eq end,
      not_eq?: fn a, b -> compare(a, b, ord) != :eq end
    }
  end

  def comparator(ord_module) do
    fn a, b -> compare(a, b, ord_module) != :gt end
  end

  def compare(a, b, ord \\ Ord) do
    ord = to_ord_map(ord)

    cond do
      ord.lt?.(a, b) -> :lt
      ord.gt?.(a, b) -> :gt
      true -> :eq
    end
  end

  def contramap(f, ord \\ Ord) do
    ord = to_ord_map(ord)

    %{
      lt?: fn a, b -> ord.lt?.(f.(a), f.(b)) end,
      le?: fn a, b -> ord.le?.(f.(a), f.(b)) end,
      ge?: fn a, b -> ord.ge?.(f.(a), f.(b)) end,
      gt?: fn a, b -> ord.gt?.(f.(a), f.(b)) end
    }
  end

  def to_ord_map(%{lt?: lt_f, le?: le_f, gt?: gt_f, ge?: ge_f} = ord_map)
      when is_function(lt_f, 2) and is_function(le_f, 2) and is_function(gt_f, 2) and
             is_function(ge_f, 2) do
    ord_map
  end

  def to_ord_map(module) when is_atom(module) do
    %{
      lt?: &module.lt?/2,
      le?: &module.le?/2,
      gt?: &module.gt?/2,
      ge?: &module.ge?/2
    }
  end
end
