defmodule RiskDice do
  @moduledoc """
  Documentation for RiskDice.
  """

  @doc """
  Returns a Map with statistics for the simulation, containing:

   * The win rate, in %
   * The average remaining troops
   * The median remaining troops

  ## Examples

      iex> RiskDice.summary([{:victory, 3}, {:victory, 11}, {:victory, 1}, {:defeat, 2}])
      %{avg_remaining: 5, med_remaining: 3, win_rate: 75.0}

  """
  def summary(data) do
    total = Enum.count(data)

    victories =
      data
      |> Enum.filter(fn {k, _} -> k == :victory end)

    med =
      victories
      |> Enum.count()
      |> Integer.floor_div(2)

    avg_remaining =
      victories
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.sum()
      |> Integer.floor_div(Enum.count(victories))

    med_remaining =
      victories
      |> Enum.sort()
      |> Enum.at(med)
      |> elem(1)

    win_rate = Enum.count(victories) / total * 100
    %{win_rate: win_rate, avg_remaining: avg_remaining, med_remaining: med_remaining}
  end

  @doc """
  Simulates a Battle for `t` times given `a` attacking troops, and `d` defending troops,
  and creates a summary.

  ## Examples

      iex> RiskDice.simulate(10, 2, 500)
      <summary>

  """
  def simulate(a, d, t) do
    1..t
    |> Enum.map(fn _ -> Battle.combat({a, d}) end)
    |> summary
  end
end
