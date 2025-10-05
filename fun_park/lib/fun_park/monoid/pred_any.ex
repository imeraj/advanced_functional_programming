defmodule FunPark.Monoid.PredAny do
  defstruct value: &FunPark.Monoid.PredAny.default_pred?/1

  def default_pred?(_), do: false
end

defimpl FunPark.Monoid, for: FunPark.Monoid.PredAny do
  alias FunPark.Monoid.PredAny

  def empty(_), do: %PredAny{}

  def append(%PredAny{} = p1, %PredAny{} = p2) do
    %PredAny{
      value: fn value -> p1.value.(value) or p2.value.(value) end
    }
  end

  def wrap(%PredAny{}, value) when is_function(value, 1) do
    %PredAny{
      value: value
    }
  end

  def unwrap(%PredAny{} = pred_all) do
    pred_all.value
  end
end
