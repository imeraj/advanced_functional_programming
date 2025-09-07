defmodule FunPark.Ride do
  @moduledoc false

  defstruct [:id, name: "Unknown Ride", min_age: 0, min_height: 0, wait_time: 0, online: true, tags: []]

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
end
