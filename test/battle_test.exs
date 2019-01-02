defmodule BattleTest do
  use ExUnit.Case
  doctest Battle

  test "roll dice as attacker" do
    attack = Battle.attack(4)
    attack_low_armies = Battle.attack(2)
    attack_lower_armies = Battle.attack(1)

    assert Enum.count(attack) == 3
    assert Enum.count(attack_low_armies) == 2
    assert Enum.count(attack_lower_armies) == 1
    assert Enum.all?(attack, fn v -> v in 1..6 end)
    assert Enum.all?(attack_low_armies, fn v -> v in 1..6 end)
    assert Enum.all?(attack_lower_armies, fn v -> v in 1..6 end)
  end

  test "roll dice as defender" do
    defend = Battle.defend(3)
    defend_low_armies = Battle.defend(1)

    assert Enum.count(defend) == 2
    assert Enum.count(defend_low_armies) == 1
    assert Enum.all?(defend, fn v -> v in 1..6 end)
    assert Enum.all?(defend_low_armies, fn v -> v in 1..6 end)
  end

  test "evaluate single roll" do
    b1 = Battle.evaluate!(5, 4)
    b2 = Battle.evaluate!(4, 5)
    b3 = Battle.evaluate!(5, 5)

    assert b1 == {0, -1}
    assert b2 == {-1, 0}
    assert b3 == {-1, 0}
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

  test "adjust armies" do
    a1 = Battle.adjust({-1, -1}, {6, 6})
    a2 = Battle.adjust({-2, 0}, {6, 6})
    a3 = Battle.adjust({0, -2}, {6, 6})

    assert a1 == {5, 5}
    assert a2 == {4, 6}
    assert a3 == {6, 4}
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
