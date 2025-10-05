defmodule FunPark.FastPass do
  @moduledoc false

  alias FunPark.Ride
  alias FunPark.Eq

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

  def eq_ride do
    Eq.Utils.contramap(&get_ride/1)
  end

  defp get_ride(%__MODULE__{ride: ride}), do: ride

  def eq_time do
    Eq.Utils.contramap(&get_time/1)
  end

  defp get_time(%__MODULE__{time: time}), do: time

  def eq_ride_and_time do
    Eq.Utils.concat_all([eq_ride(), eq_time()])
  end

  def duplicate_pass do
    Eq.Utils.concat_any([Eq, eq_ride_and_time()])
  end

  def valid?(%__MODULE__{} = fast_pass, %Ride{} = ride) do
    Eq.Utils.eq?(get_ride(fast_pass), ride)
  end

  defimpl FunPark.Eq, for: FunPark.FastPass do
    alias FunPark.Eq
    alias FunPark.FastPass

    def eq?(%FastPass{id: v1}, %FastPass{id: v2}), do: Eq.eq?(v1, v2)
    def not_eq?(%FastPass{id: v1}, %FastPass{id: v2}), do: Eq.not_eq?(v1, v2)
  end

  defimpl FunPark.Ord, for: FunPark.FastPass do
    alias FunPark.Ord
    alias FunPark.FastPass

    def lt?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.lt?(v1, v2)
    def le?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.le?(v1, v2)
    def gt?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.gt?(v1, v2)
    def ge?(%FastPass{time: v1}, %FastPass{time: v2}), do: Ord.ge?(v1, v2)
  end
end
