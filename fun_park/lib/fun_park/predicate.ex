defmodule FunPark.Predicate do
  import FunPark.Monoid.Utils, only: [m_append: 3, m_concat: 2]
  alias FunPark.Monoid.{PredAll, PredAny}

  def p_all(pred1, pred2) when is_function(pred1) and is_function(pred2) do
    m_append(%PredAll{}, pred1, pred2)
  end

  def p_any(pred1, pred2) when is_function(pred1) and is_function(pred2) do
    m_append(%PredAny{}, pred1, pred2)
  end

  def p_not(pred) when is_function(pred) do
    fn value -> not pred.(value) end
  end

  def p_all(p_list) when is_list(p_list) do
    m_concat(%PredAll{}, p_list)
  end

  def p_any(p_list) when is_list(p_list) do
    m_concat(%PredAny{}, p_list)
  end

  def p_none(p_list) when is_list(p_list) do
    p_not(m_concat(%PredAny{}, p_list))
  end
end

defimpl FunPark.Foldable, for: Function do
  def fold_l(predicate, true_func, false_func) do
    case predicate.() do
      true -> true_func.()
      false -> false_func.()
    end
  end

  def fold_r(predicate, true_func, false_func) do
    fold_l(predicate, true_func, false_func)
  end
end
