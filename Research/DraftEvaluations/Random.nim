import std / random
import .. / .. / Engine / [Card, Config, Draft, State]

proc evaluateDraftRandom * (config: Config, state: State): DraftResult =
  state.evaluateDraftWith(proc (card: Card): float = rand(1.0))
