defmodule Battle do
  @moduledoc """
  The Battle module holds the logic for a simulated RISK Battle, where the attacking and defending
  armies make war using dice.

  Following rules applies:

  1. The attacker and the defender rolls 1-3 dice. *
  2. the highest roll of the attacker are matched vs the highest roll of the attacker.
  3. The second highest pair are matched.
  4. The armies are adjusted. **
  5. Repeat 1-4 until no armies remain for one of the sides.

  ## ROLL RULES:

   * The attacker rolls 3 dice if the army count is 3 or above, else the number of armies get a die:
     2 armies, 2 dice, 1 army, 1 die and so on.
   * The defender rolls 2 dice if the army count is 2 or above, otherwise rolls 1 die.

  ## ADJUSTMENT RULES:

  For each pair of dice,

   * If the attacker dice are higher than the defender, the defender loose 1 troop.
   * If the defender dice are higher than the attacker, the attacker loose 1 troop.
   * If the dice are equal, the attacker loose 1 troop.
  """

  @doc """
  Adjust remaining troops by a changeset tuple.

  ## Examples

    iex> Battle.adjust({-1, -1}, {6, 6})
    {5, 5}
    iex> Battle.adjust({-2, 0}, {6, 6})
    {4, 6}
    iex> Battle.adjust({0, -2}, {6, 6})
    {6, 4}

  """

  def adjust(troops, remaining) do
    [troops, remaining]
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sum/1)
    |> List.to_tuple()
  end

  @doc """
  Roll attack dice: 1-3 dice depending on troop count.

  ## Examples

    iex> Battle.attack(10) |> Enum.count()
    3
    iex> Battle.attack(2) |> Enum.count()
    2
    iex> Battle.attack(1) |> Enum.count()
    1

  """

  def attack(troops), do: roll_dice(troops, 3)

  @doc """
  Roll defence dice: 1-2 dice depending on troop count.

  ## Examples

    iex> Battle.attack(10) |> Enum.count()
    3
    iex> Battle.attack(1) |> Enum.count()
    1

  """

  def defend(troops), do: roll_dice(troops, 2)

  @doc """
  Single dice evaluation. On equal values, defence wins.

  ## Examples

    iex> Battle.evaluate!(5, 4)
    {0, -1}
    iex> Battle.evaluate!(4, 5)
    {-1, 0}
    iex> Battle.evaluate!(5, 5)
    {-1, 0}

  """

  def evaluate!(a, d), do: if(a > d, do: {0, -1}, else: {-1, 0})

  @doc """
  Multiple dice evaluation. Returns the following:

  {-2, 0} or {-1, 0} if attacker lost,
  {0, -2} or {0, -1} if defender lost, or
  {-1, -1} if both lost 1 troop.
  """

  def evaluate(dice) do
    {a, d} = dice

    Enum.zip(a, d)
    |> Enum.map(fn {a, d} -> evaluate!(a, d) end)
    |> Enum.unzip()
    |> Tuple.to_list()
    |> Enum.map(&Enum.sum/1)
    |> List.to_tuple()
  end

  @doc """
  Return a minimum `m` number of dice (integers, 1-6), sorted in reverse order.
  """
  def roll_dice(troops, m) do
    e = min(m, troops)

    1..e
    |> Enum.map(fn _ -> Enum.random(1..6) end)
    |> Enum.sort(&(&1 >= &2))
  end

  @doc """
  Roll attack and defence dice: 1-3 for attack, 1-2 for defence.

  Returns a tuple of 2 lists, created by `roll_dice/2`.
  """

  def roll({a, d}) do
    attackers = attack(a)
    defenders = defend(d)
    {attackers, defenders}
  end

  @doc """
  A *combat* consists of

  1. Dice roll (`roll/2`): Attackers and defence roll dice according to *Roll rules*. Optionally adding dice
    Enhancements (`Enhancement.enhance_dice/2`),
  2. Dice evaluation (`evaluate/1`): Each dice are matched according to rules.
  3. remaining troops are adjusted bases on losses.
  4. If any side has zero (0) troops left, :defeat or :victory is declared and remaining troops on the winning
    side is revealed.
  5. However, if both sides still got troops, the next combat is inititated directly.

  ## Examples
  """

  def combat(troops, options \\ [])

  def combat({remaining, lost}, _options) when lost <= 0, do: {:victory, remaining}

  def combat({lost, remaining}, _options) when lost <= 0, do: {:defeat, remaining}

  def combat(troops, options) do
    troops
    |> roll
    |> Enhancement.enhance_dice(options)
    |> evaluate
    |> adjust(troops)
    |> combat(options)
  end
end
