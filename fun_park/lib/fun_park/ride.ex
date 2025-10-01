defmodule FunPark.Ride do
  @moduledoc false

  require FunPark.Macros
  import FunPark.Predicate
  import FunPark.Utils

  alias FunPark.Patron

  defstruct [
    :id,
    name: "Unknown Ride",
    min_age: 0,
    min_height: 0,
    wait_time: 0,
    online: true,
    tags: []
  ]

  def new(name, opts \\ []) when is_binary(name) do
    %__MODULE__{
      id: :erlang.unique_integer([:positive]),
      name: name,
      min_age: Keyword.get(opts, :min_age, 0),
      min_height: Keyword.get(opts, :min_height, 0),
      wait_time: Keyword.get(opts, :wait_time, 0),
      online: Keyword.get(opts, :online, true),
      tags: Keyword.get(opts, :tags, [])
    }
  end

  def change(%__MODULE__{} = ride, attrs) when is_map(attrs) do
    attrs = Map.delete(attrs, :id)

    struct(ride, attrs)
  end

  defimpl FunPark.Eq, for: FunPark.Ride do
    alias FunPark.Eq
    alias FunPark.Ride

    def eq?(%Ride{id: v1}, %Ride{id: v2}), do: Eq.eq?(v1, v2)
    def not_eq?(%Ride{id: v1}, %Ride{id: v2}), do: Eq.not_eq?(v1, v2)
  end

  FunPark.Macros.ord_for(FunPark.Ride, :name)

  def online?(%__MODULE__{online: online}), do: online

  def long_wait?(%__MODULE__{wait_time: wait_time}), do: wait_time > 30

  def tall_enough?(%Patron{} = patron, %__MODULE__{} = ride),
    do: Patron.get_height(patron) >= ride.min_height

  def old_enough?(%Patron{} = patron, %__MODULE__{} = ride),
    do: Patron.get_age(patron) >= ride.min_age

  def suggested?(%__MODULE__{} = ride),
    do: p_all([&online?/1, p_not(&long_wait?/1)]).(ride)

  def suggested?(%Patron{} = patron, %__MODULE__{} = ride) do
    p_all([&suggested?/1, curry(&eligible?/2).(patron)]).(ride)
  end

  def eligible?(%Patron{} = patron, %__MODULE__{} = ride),
    do: p_all([curry(&tall_enough?/2).(patron), curry(&old_enough?/2).(patron)]).(ride)
end
