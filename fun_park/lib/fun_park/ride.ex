defmodule FunPark.Ride do
  @moduledoc false

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

  defimpl FunPark.Ord, for: FunPark.Ride do
    alias FunPark.Ord
    alias FunPark.Ride

    def lt?(%Ride{name: v1}, %Ride{name: v2}), do: Ord.lt?(v1, v2)
    def le?(%Ride{name: v1}, %Ride{name: v2}), do: Ord.le?(v1, v2)
    def gt?(%Ride{name: v1}, %Ride{name: v2}), do: Ord.gt?(v1, v2)
    def ge?(%Ride{name: v1}, %Ride{name: v2}), do: Ord.ge?(v1, v2)
  end
end
