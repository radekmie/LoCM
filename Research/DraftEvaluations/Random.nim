import std / random
import .. / .. / Engine / [Card, Draft, State]

proc evaluateDraftRandom * (state: State): DraftResult =
  state.evaluateDraftWith(proc (card: Card): float = rand(1.0))
