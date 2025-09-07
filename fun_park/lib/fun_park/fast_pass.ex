defmodule FunPark.FastPass do
  @moduledoc false

  alias FunPark.Ride

  defstruct [:id, ride: nil, time: nil]

  def new(%Ride{} = ride, %DateTime{} = time) do
    %__MODULE__{
      id: :erlang.unique_integer([:positive]),
      ride: ride,
      time: time
    }
  end

  def change(%__MODULE__{} = fast_pass, attrs) when is_map(attrs) do
    attrs = Map.delete(attrs, :id)

    struct(fast_pass, attrs)
  end

  defimpl FunPark.Eq, for: FunPark.FastPass do
    alias FunPark.Eq
    alias FunPark.FastPass

    def eq?(%FastPass{id: v1}, %FastPass{id: v2}), do: Eq.eq?(v1, v2)
    def not_eq?(%FastPass{id: v1}, %FastPass{id: v2}), do: Eq.not_eq?(v1, v2)
  end
end
