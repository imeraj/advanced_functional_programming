defmodule FunPark.Math do
  import FunPark.Monoid.Utils, only: [m_append: 3, m_concat: 2]
  alias FunPark.Monoid.Sum
  alias FunPark.Monoid.Max

  def sum(a, b) do
    m_append(%Sum{}, a, b)
  end

  def sum(list) when is_list(list) do
    m_concat(%Sum{}, list)
  end

  def max(a, b) do
    m_append(%Max{value: Float.min_finite()}, a, b)
  end

  def max(list) when is_list(list) do
    m_concat(%Max{value: Float.min_finite()}, list)
  end
end
