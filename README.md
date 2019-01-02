# RiskDice

A simulator for RISK battles, simulating an attacking army of `x` troops vs a defending army of `y` troops, fighting
each other `z` times.

When all `z` battles has been simulated, the following questions are answered:

 * How possible is it for the attacking army to win? (`win_rate`, %)
 * How many troops will remain on average? (`avg_remaining`)
 * How many troops will remain on median? (`med_remaining`)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `risk_dice` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:risk_dice, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/risk_dice](https://hexdocs.pm/risk_dice).

