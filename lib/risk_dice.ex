defmodule RiskDice do
  @moduledoc """
  RISK Battle Simulator: How likely is it for you to win, and what will the remaining troops likely be?
  """

  @doc """
  Simulate a RISK battle for `attacking_troops` attacking `defending_troops`, for `num` times. Let `num` be a
  *high* number.
  """
  def simulate(attacking_troops, defending_troops, num) do
    1..num
    |> Enum.map(fn _ -> Battle.combat({attacking_troops, defending_troops}) end)
    |> Summary.create()
  end
end
