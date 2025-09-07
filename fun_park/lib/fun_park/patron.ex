defmodule FunPark.Patron do
  @moduledoc false

  defstruct id: nil,
            name: nil,
            age: 0,
            height: 0,
            ticket_tier: :basic,
            fast_passes: [],
            reward_points: 0,
            likes: [],
            dislikes: []

  def new(name, age, height, opts \\ [])
      when is_bitstring(name) and
             is_integer(age) and
             is_integer(height) and
             age > 0 and
             height > 0 do
    %__MODULE__{
      id: :erlang.unique_integer([:positive]),
      name: name,
      age: age,
      height: height,
      ticket_tier: Keyword.get(opts, :ticket_tier, :basic),
      fast_passes: Keyword.get(opts, :fast_passes, []),
      reward_points: Keyword.get(opts, :reward_points, 0),
      likes: Keyword.get(opts, :likes, []),
      dislikes: Keyword.get(opts, :dislikes, [])
    }
  end
end
