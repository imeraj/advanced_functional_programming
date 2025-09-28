defmodule FunPark.Monoid.PredAll do
  defstruct value: &FunPark.Monoid.PredAll.default_pred?/1

  def default_pred?(_), do: true
end

defimpl FunPark.Monoid, for: FunPark.Monoid.PredAll do
  alias FunPark.Monoid.PredAll

  def empty(_), do: %PredAll{}

  def append(%PredAll{} = p1, %PredAll{} = p2) do
    %PredAll{
      value: fn value -> p1.value.(value) and p2.value.(value) end
    }
  end

  def wrap(%PredAll{}, value) when is_function(value, 1) do
    %PredAll{
      value: value
    }
  end

  def unwrap(%PredAll{} = pred_all) do
    pred_all.value
  end
end
