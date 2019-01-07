defmodule RiskDice do
  @moduledoc """
  RISK Battle Simulator: How likely is it for you to win, and what will the remaining troops likely be?
  """

  @doc """
  Simulate a RISK battle for `attacking_troops` attacking `defending_troops`, for `num` times. Let `num` be a
  *high* number.

  `options` is an optional list of strings, containing any of the following:

  * `is_fort` - +1 on the highest die for the defending troops
  * `has_hero` - +1 on the highest die for the attacking troops
  * `can_use_1_die` - Allows the defender to use 1 die instead of 2 dice when
    the attacking troop's dice are to good (6,6, 6,5, 6,4 or 5,5)

  """
  def simulate(attacking_troops, defending_troops, num, options \\ []) do
    1..num
    |> Enum.map(fn _ -> Battle.combat({attacking_troops, defending_troops}, options) end)
    |> Summary.create()
  end
end
