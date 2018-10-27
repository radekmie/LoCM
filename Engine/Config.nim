import std / random
import Draft, Search, State

type
  Config * = ref object
    playAlgorithm *: proc (config: Config): proc (state: State): SearchResult
    evaluateDraft *: proc (state: State): DraftResult
    evaluateState *: proc (state: State): float
    seed          *: int
    time          *: float

func eval * (config: Config): proc (state: State): DraftResult =
  config.evaluateDraft

proc play * (config: Config): proc (state: State): SearchResult =
  config.seed.randomize
  config.time /= 1000
  config.playAlgorithm(config)
