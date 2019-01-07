defmodule EnhancementTest do
  use ExUnit.Case
  doctest Enhancement

  test "do nothing" do
    b1 = Enhancement.enhance_dice({[4, 4, 4], [4, 4]})

    assert b1 == {[4, 4, 4], [4, 4]}
  end

  test "apply hero bonus" do
    b1 = Enhancement.enhance_dice({[4, 4, 4], [4, 4]}, ["has_hero"])

    assert b1 == {[5, 4, 4], [4, 4]}
  end

  test "apply fort bonus" do
    b1 = Enhancement.enhance_dice({[4, 4, 4], [4, 4]}, ["is_fort"])

    assert b1 == {[4, 4, 4], [5, 4]}
  end

  test "apply hero and fort bonuses" do
    b1 = Enhancement.enhance_dice({[4, 4, 4], [4, 4]}, ["is_fort", "has_hero"])

    assert b1 == {[5, 4, 4], [5, 4]}
  end

  test "can_use_1_die applies before bonuses are added" do
    b1 = Enhancement.enhance_dice({[5, 4, 4], [4, 4]}, ["has_hero", "can_use_1_die"])
    b2 = Enhancement.enhance_dice({[5, 4, 4], [4, 4]}, ["has_hero", "is_fort", "can_use_1_die"])
    b3 = Enhancement.enhance_dice({[5, 5, 4], [4, 4]}, ["has_hero", "is_fort", "can_use_1_die"])
    b4 = Enhancement.enhance_dice({[5, 5, 4], [4, 4]}, ["has_hero", "can_use_1_die"])

    assert b1 == {[6, 4, 4], [4, 4]}
    assert b2 == {[6, 4, 4], [5, 4]}
    assert b3 == {[6, 5, 4], [5]}
    assert b4 == {[6, 5, 4], [4]}
  end
end
