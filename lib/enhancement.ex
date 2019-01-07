defmodule Enhancement do
  @moduledoc """
  Several enhancement exists in the Battle game.

  DICE BONUS

  In some cases a dice bonus is applied.

   * A *hero* may join the attacking troops. It should not count as a troop, but will apply +1 to the highest die
     each time the troops attack.
   * The defending troops may defend a *fort*. The fort applies +1 to the highest die each time the troops defend.

  STRATEGIC BENEFIT

  In some cases a strategic benefit is applied.

   * If the attacking troops' dice are overwhelming, the defending troops can choose to only defend with 1 die, and
     only risk losing 1 troop instead of losing 2 (in case of several dice).
  """

  @has_hero "has_hero"
  @is_fort "is_fort"
  @can_use_1_die "can_use_1_die"

  @doc """
  Add +1 to the first item in a list of integers (dice).

  ## Examples

    iex> Enhancement.plus1([4, 3])
    [5, 3]
    iex> Enhancement.plus1([2])
    [3]
    iex> Enhancement.plus1([2, 1, 1])
    [3, 1, 1]

  """
  def plus1(dice) do
    [head | tail] = dice
    [head + 1 | tail]
  end

  @doc """
  Applies +1 to highest die if the defending troops defends a fortification.

  ## Examples

    iex> Enhancement.fort_bonus({[4, 3], [4, 3]}, true)
    {[4, 3], [5, 3]}

    iex> Enhancement.fort_bonus({[4], [4]}, true)
    {[4], [5]}

    iex> Enhancement.fort_bonus({[4, 3], [4, 3]}, false)
    {[4, 3], [4, 3]}

    iex> Enhancement.fort_bonus({[4], [4]}, false)
    {[4], [4]}
  """
  def fort_bonus(dice, is_fort?) when not is_fort?, do: dice

  def fort_bonus(dice, is_fort?) when is_fort? do
    {a, d} = dice
    {a, plus1(d)}
  end

  @doc """
  Applies +1 to highest attacking die if the attacking troops has a hero.

  ## Examples

    iex> Enhancement.hero_bonus({[6, 4, 3], [4, 3]}, true)
    {[7, 4, 3], [4, 3]}

    iex> Enhancement.hero_bonus({[4, 3], [4, 3]}, true)
    {[5, 3], [4, 3]}

    iex> Enhancement.hero_bonus({[4], [4]}, true)
    {[5], [4]}

    iex> Enhancement.hero_bonus({[6, 4, 3], [4, 3]}, false)
    {[6, 4, 3], [4, 3]}

    iex> Enhancement.hero_bonus({[4, 3], [4, 3]}, false)
    {[4, 3], [4, 3]}

    iex> Enhancement.hero_bonus({[4], [4]}, false)
    {[4], [4]}

  """
  def hero_bonus(dice, has_hero?) when not has_hero?, do: dice

  def hero_bonus(dice, has_hero?) when has_hero? do
    {a, d} = dice
    {plus1(a), d}
  end

  @doc """
  Removes 1 defending die of the attacking dice are to good (has the sum 10 or higher).

  ## Examples

    iex> Enhancement.strong_offence_benefit({[6, 4, 3], [3, 3]}, true)
    {[6, 4, 3], [3]}

    iex> Enhancement.strong_offence_benefit({[6, 5], [3, 3]}, true)
    {[6, 5], [3]}

    iex> Enhancement.strong_offence_benefit({[4], [4]}, true)
    {[4], [4]}

    iex> Enhancement.strong_offence_benefit({[6, 4, 3], [3, 3]}, false)
    {[6, 4, 3], [3, 3]}

    iex> Enhancement.strong_offence_benefit({[6, 5], [3, 3]}, false)
    {[6, 5], [3, 3]}

    iex> Enhancement.strong_offence_benefit({[4], [4]}, false)
    {[4], [4]}

  """
  def strong_offence_benefit(dice = {[_], _}, _can_use_1_die?), do: dice

  def strong_offence_benefit(dice, can_use_1_die?) when not can_use_1_die?, do: dice

  def strong_offence_benefit(dice = {[highest, near_highest | tail], d}, can_use_1_die?)
      when can_use_1_die? do
    if highest + near_highest > 9 do
      {[highest, near_highest | tail], Enum.random(d) |> List.wrap()}
    else
      dice
    end
  end

  def add_dice_bonus(dice, options \\ []) do
    dice
    |> fort_bonus(@is_fort in options)
    |> hero_bonus(@has_hero in options)
  end

  def add_benefit(dice, options \\ []) do
    dice
    |> strong_offence_benefit(@can_use_1_die in options)
  end
end
