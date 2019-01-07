defmodule BattleTest do
  use ExUnit.Case
  doctest Battle

  test "roll dice" do
    dice = Battle.roll_dice(4, 6)

    assert is_list(dice)
    assert Enum.all?(dice, fn v -> v in 1..6 end)
    assert Enum.count(dice) == 4
    assert dice == Enum.sort(dice, &(&1 >= &2))
  end

  test "roll attack and defence dice" do
    {a1, d1} = Battle.roll({10, 6})
    {a2, d2} = Battle.roll({2, 6})
    {a3, d3} = Battle.roll({2, 1})
    {a4, d4} = Battle.roll({1, 1})

    assert Enum.count(a1) == 3 and Enum.count(d1) == 2
    assert Enum.count(a2) == 2 and Enum.count(d2) == 2
    assert Enum.count(a3) == 2 and Enum.count(d3) == 1
    assert Enum.count(a4) == 1 and Enum.count(d4) == 1
  end

  test "evaluate 3 vs 2 rolls" do
    b1 = Battle.evaluate({[6, 6, 6], [4, 4]})
    b2 = Battle.evaluate({[4, 3, 1], [5, 4]})
    b3 = Battle.evaluate({[4, 3, 2], [4, 3]})
    b4 = Battle.evaluate({[2, 2, 2], [2, 1]})
    b5 = Battle.evaluate({[2, 2, 1], [2, 2]})

    assert b1 == {0, -2}
    assert b2 == {-2, 0}
    assert b3 == {-2, 0}
    assert b4 == {-1, -1}
    assert b5 == {-2, 0}
  end

  test "evaluate 3 vs 1 rolls" do
    b1 = Battle.evaluate({[6, 6, 6], [4]})
    b2 = Battle.evaluate({[4, 3, 1], [5]})
    b3 = Battle.evaluate({[4, 3, 2], [4]})

    assert b1 == {0, -1}
    assert b2 == {-1, 0}
    assert b3 == {-1, 0}
  end

  test "evaluate 2 vs 1 rolls" do
    b1 = Battle.evaluate({[6, 6], [4]})
    b2 = Battle.evaluate({[4, 3], [5]})
    b3 = Battle.evaluate({[4, 3], [4]})

    assert b1 == {0, -1}
    assert b2 == {-1, 0}
    assert b3 == {-1, 0}
  end

  test "evaluate 2 vs 2 rolls" do
    b1 = Battle.evaluate({[6, 6], [6, 4]})
    b4 = Battle.evaluate({[6, 4], [5, 4]})
    b2 = Battle.evaluate({[4, 3], [5, 4]})
    b3 = Battle.evaluate({[4, 3], [3, 2]})

    assert b1 == {-1, -1}
    assert b4 == {-1, -1}
    assert b2 == {-2, 0}
    assert b3 == {0, -2}
  end

  test "claims victory" do
    assert Battle.combat({4, 0}) == {:victory, 4}
    assert Battle.combat({4, -1}) == {:victory, 4}
  end

  test "claims defeat" do
    assert Battle.combat({0, 2}) == {:defeat, 2}
    assert Battle.combat({-1, 2}) == {:defeat, 2}
  end
end
