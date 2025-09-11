defprotocol FunPark.Eq do
  @fallback_to_any true

  def eq?(a, b)
  def not_eq?(a, b)
end

defimpl FunPark.Eq, for: Any do
  def eq?(a, b), do: a == b
  def not_eq?(a, b), do: a != b
end
