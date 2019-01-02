defmodule Battle do
  @moduledoc """
  RISK Battle, where the attacking and defending armies make war using dice. Following rules applies:
  1. The attacker and the defender rolls 1-3 dice. *
  2. the highest roll of the attacker are matched vs the highest roll of the attacker.
  3. The second highest pair are matched.
  4. The armies are adjusted. **
  5. Repeat 1-4 until no armies remain for one of the sides.

  * ROLL RULES:

   * The attacker rolls 3 dice if the army count is 3 or above, else the number of armies get a die:
     2 armies, 2 dice, 1 army, 1 die and so on.
   * The defender rolls 2 dice if the army count is 2 or above, otherwise rolls 1 die.

  ** ADJUSTMENT RULES:

  For each pair of dice,

   * If the attacker dice are higher than the defender, the defender loose 1 troop.
   * If the defender dice are higher than the attacker, the attacker loose 1 troop.
   * If the dice are equal, the attacker loose 1 troop.
  """
  defp roll_die(troops, m) do
    e = min(m, troops)

    1..e
    |> Enum.map(fn _ -> Enum.random(1..6) end)
    |> Enum.sort(&(&1 >= &2))
  end

  def attack(troops), do: roll_die(troops, 3)

  def defend(troops), do: roll_die(troops, 2)

  def roll({a, d}) do
    attackers = attack(a)
    defenders = defend(d)
    {attackers, defenders}
  end

  def evaluate!(a, d), do: if(a > d, do: {0, -1}, else: {-1, 0})

  def evaluate({a, d}) do
    Enum.zip(a, d)
    |> Enum.map(fn {a, d} -> evaluate!(a, d) end)
    |> Enum.unzip()
    |> Tuple.to_list()
    |> Enum.map(&Enum.sum/1)
    |> List.to_tuple()
  end

  def adjust(troops, remaining) do
    [troops, remaining]
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sum/1)
    |> List.to_tuple()
  end

  def combat({remaining, lost}) when lost <= 0, do: {:victory, remaining}

  def combat({lost, remaining}) when lost <= 0, do: {:defeat, remaining}

  def combat(troops) do
    troops
    |> roll
    |> evaluate
    |> adjust(troops)
    |> combat
  end
end
