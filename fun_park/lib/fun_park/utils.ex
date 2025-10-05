defmodule FunPark.Utils do
  def curry(fun) when is_function(fun) do
    arity = :erlang.fun_info(fun, :arity) |> elem(1)
    curry(fun, arity, [])
  end

  defp curry(fun, 1, args), do: fn last_arg -> apply(fun, args ++ [last_arg]) end

  defp curry(fun, arity, args) when arity > 1 do
    fn next_arg -> curry(fun, arity - 1, args ++ [next_arg]) end
  end

  def curry_r(fun) when is_function(fun) do
    arity = :erlang.fun_info(fun, :arity) |> elem(1)
    curry_r(fun, arity, [])
  end

  defp curry_r(fun, 1, args), do: fn last_arg -> apply(fun, [last_arg | args]) end

  defp curry_r(fun, arity, args) when arity > 1 do
    fn next_arg -> curry_r(fun, arity - 1, [next_arg | args]) end
  end
end
