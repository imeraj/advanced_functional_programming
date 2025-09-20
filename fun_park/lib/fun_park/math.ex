defmodule FunPark.Math do
  import FunPark.Monoid.Utils, only: [m_append: 3, m_concat: 2]
  alias FunPark.Monoid.Sum

  def sum(a, b) do
    m_append(%Sum{}, a, b)
  end

  def sum(list) when is_list(list) do
    m_concat(%Sum{}, list)
  end
end
