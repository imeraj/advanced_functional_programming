defmodule FunPark.Patron do
  @moduledoc false

  require FunPark.Macros

  import FunPark.Monoid.Utils, only: [m_concat: 2]

  alias FunPark.Math
  alias FunPark.List
  alias FunPark.Monoid.Max
  alias FunPark.Ord.Utils

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

  def change(%__MODULE__{} = patron, attrs) when is_map(attrs) do
    attrs = Map.delete(attrs, :id)

    struct(patron, attrs)
  end

  defimpl FunPark.Eq, for: FunPark.Patron do
    alias FunPark.Eq
    alias FunPark.Patron

    def eq?(%Patron{id: v1}, %Patron{id: v2}), do: Eq.eq?(v1, v2)
    def not_eq?(%Patron{id: v1}, %Patron{id: v2}), do: Eq.not_eq?(v1, v2)
  end

  FunPark.Macros.ord_for(FunPark.Patron, :name)

  def get_height(%__MODULE__{height: height}), do: height
  def get_age(%__MODULE__{age: age}), do: age

  defp tier_priority(:basic), do: 1
  defp tier_priority(:premium), do: 2
  defp tier_priority(:vip), do: 3
  defp tier_priority(_), do: 0

  defp get_ticket_tier_priority(%__MODULE__{ticket_tier: ticket_tier}),
    do: tier_priority(ticket_tier)

  def ord_by_ticket_tier do
    Utils.contramap(&get_ticket_tier_priority/1)
  end

  defp get_reward_points(%__MODULE__{reward_points: reward_points}),
    do: reward_points

  def ord_by_reward_points do
    Utils.contramap(&get_reward_points/1)
  end

  def ord_by_priority do
    Ord.Utils.concat([
      ord_by_ticket_tier(),
      ord_by_reward_points(),
      Ord
    ])
  end

  def vip?(%__MODULE__{ticket_tier: :vip}), do: true
  def vip?(_), do: false

  def priority_empty do
    %__MODULE__{reward_points: Float.min_finite(), ticket_tier: nil}
  end

  defp max_priority_monoid do
    %Max{value: priority_empty(), ord: ord_by_priority()}
  end

  def highest_priority(patrons) when is_list(patrons) do
    m_concat(max_priority_monoid(), patrons)
  end

  def get_fast_passes(%__MODULE__{fast_passes: fast_passes}),
    do: fast_passes

  def add_fast_pass(%__MODULE__{} = patron, fast_pass) do
    fast_passes = List.union([fast_pass], get_fast_passes(patron))

    change(patron, %{fast_passes: fast_passes})
  end

  def remove_fast_pass(%__MODULE__{} = patron, fast_pass) do
    fast_passes = List.difference(get_fast_passes(patron), [fast_pass])

    change(patron, %{fast_passes: fast_passes})
  end

  def promotion(%__MODULE__{} = patron, points) do
    new_points = Math.sum(get_reward_points(patron), points)

    change(patron, %{reward_points: new_points})
  end
end
