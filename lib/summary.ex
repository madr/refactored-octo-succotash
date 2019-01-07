defmodule Summary do
  @moduledoc """
  The Summary module contains logic to summarize a number of RISK Battle simulations.

  Focused are the win rate (How likely is a win for this battle?) and the remaining
  troops (will the battle be worth it?)

  * The win rate, in %, rounded by 2 decimal digits
  * The average remaining troops for all battles.
  * The median remaining troops

  """

  @doc """
  Get the average remaining troops of a list of victories.

  ## Examples

      iex> Summary.avg_remaining([3, 4, 5])
      4
      iex> Summary.avg_remaining([1, 1, 1, 5])
      2

  """
  def avg_remaining(victories) do
    num = Enum.count(victories)

    victories
    |> Enum.sum()
    |> Integer.floor_div(num)
  end

  @doc """
  Get the remaining troops at median position of a list of victories.

  ## Examples

      iex> Summary.med_remaining([1, 6, 7])
      6
      iex> Summary.med_remaining([1, 6, 7, 8])
      7

  """
  def med_remaining(victories) do
    pos =
      victories
      |> Enum.count()
      |> Integer.floor_div(2)

    victories
    |> Enum.sort()
    |> Enum.at(pos)
  end

  @doc """
  Filter out the victories from a list of battles.

  ## Examples

      iex> Summary.victories([{:victory, 1}, {:defeat, 6}, {:victory, 7}])
      [1, 7]

  """
  def victories(battles) do
    battles
    |> Enum.filter(fn {k, _} -> k == :victory end)
    |> Enum.map(fn {_, v} -> v end)
  end

  @doc """
  Returns the win rate percentage (2 decimals) of a list of battles.

  ## Examples

      iex> Summary.win_rate([{:victory, 1}, {:defeat, 6}])
      50.0

      iex> Summary.win_rate([{:victory, 1}, {:defeat, 6}, {:victory, 7}])
      66.67

      iex> Summary.win_rate([{:victory, 1}, {:defeat, 6}, {:defeat, 7}])
      33.33

  """
  def win_rate(battles) do
    total = Enum.count(battles)

    battles
    |> victories
    |> Enum.count()
    |> (&(&1 / &2)).(total)
    |> (&(&1 * 100)).()
    |> Float.round(2)
  end

  @doc """
  Returns a Map with statistics for the simulation, containing:

   * The win rate, in %
   * The average remaining troops
   * The median remaining troops

  ## Examples

      iex> Summary.create([{:victory, 3}, {:victory, 11}, {:victory, 1}, {:defeat, 2}])
      %{avg_remaining: 5, med_remaining: 3, win_rate: 75.0}

  """
  def create(battles) do
    win_rate = win_rate(battles)
    victories = victories(battles)
    avg_remaining = avg_remaining(victories)
    med_remaining = med_remaining(victories)
    %{win_rate: win_rate, avg_remaining: avg_remaining, med_remaining: med_remaining}
  end
end
