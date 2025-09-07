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
end
