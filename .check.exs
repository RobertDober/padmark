[
  tools: [
    {:dialyzer, false},
    # when the Elixir errors regarding Regex.run are fixed, then we could change to hybrid
    {:prisma, "mix prisma --mode discrepancy", env: %{"MIX_ENV" => "test"}}
  ]
]
