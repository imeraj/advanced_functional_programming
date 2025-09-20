defmodule FunPark.List do
  @moduledoc """
  Harness equality for collections
  """

  def uniq(list, eq \\ FunPark.Eq) when is_list(list) do
    Enum.reduce(list, [], fn item, acc ->
      if Enum.any?(acc, &FunPark.Eq.Utils.eq?(item, &1, eq)),
        do: acc,
        else: [item | acc]
    end)
    |> Enum.reverse()
  end

  def union(list1, list2, eq \\ FunPark.Eq) when is_list(list1) and is_list(list2) do
    uniq(list1 ++ list2, eq)
  end

  def intersection(list1, list2, eq \\ FunPark.Eq) when is_list(list1) and is_list(list2) do
    list1
    |> Enum.filter(fn item ->
      Enum.any?(list2, &FunPark.Eq.Utils.eq?(item, &1, eq))
    end)
    |> uniq(eq)
  end

  def difference(list1, list2, eq \\ FunPark.Eq) when is_list(list1) and is_list(list2) do
    list1
    |> Enum.reject(fn item ->
      Enum.any?(list2, &FunPark.Eq.Utils.eq?(item, &1, eq))
    end)
    |> uniq(eq)
  end

  def symmetric_difference(list1, list2, eq \\ FunPark.Eq)
      when is_list(list1) and is_list(list2) do
    (difference(list1, list2, eq) ++ difference(list2, list1, eq))
    |> uniq(eq)
  end

  def subset?(small, large, eq \\ FunPark.Eq) when is_list(small) and is_list(large) do
    Enum.all?(small, fn item ->
      Enum.any?(large, &FunPark.Eq.Utils.eq?(item, &1, eq))
    end)
  end

  def superset?(large, small, eq \\ FunPark.Eq) when is_list(small) and is_list(large) do
    subset?(small, large, eq)
  end

  def sort(list, ord \\ FunPark.Ord) when is_list(list) do
    Enum.sort(list, FunPark.Ord.Utils.comparator(ord))
  end

  def strict_sort(list, ord \\ FunPark.Ord) when is_list(list) do
    list
    |> uniq(FunPark.Ord.Utils.to_eq(ord))
    |> sort(ord)
  end

  defimpl FunPark.Foldable, for: List do
    def fold_l(list, acc, func), do: List.foldl(list, acc, func)
    def fold_r(list, acc, func), do: List.foldr(list, acc, func)
  end
end
