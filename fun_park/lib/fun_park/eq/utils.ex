defmodule FunPark.Eq.Utils do
  @moduledoc """
  Utility functions for working with equality data.
  """
  alias FunPark.Eq

  def contramap(f, eq \\ Eq) do
    eq = to_eq_map(eq)

    %{
      eq?: fn a, b -> eq.eq?.(f.(a), f.(b)) end,
      not_eq?: fn a, b -> eq.not_eq?.(f.(a), f.(b)) end
    }
  end

  def eq?(a, b, eq \\ Eq) do
    eq = to_eq_map(eq)
    eq.eq?.(a, b)
  end

  defp to_eq_map(%{eq?: eq_fun, not_eq?: not_eq_fun} = eq_map)
       when is_function(eq_fun, 2) and is_function(not_eq_fun, 2) do
    eq_map
  end

  defp to_eq_map(module) when is_atom(module) do
    %{
      eq?: &module.eq?/2,
      not_eq?: &module.not_eq?/2
    }
  end
end
