import std / strformat
import Card, State

type
  DraftResult * = ref object
    scores *: seq[float]
    state  *: State

func `$` * (draftResult: DraftResult): string =
  var bestIndex: int
  var bestScore: float = -99999

  for index, score in draftResult.scores:
    if score > bestScore:
      bestIndex = index
      bestScore = score

  &"PICK {bestIndex} # score: {bestScore}"

func evaluateDraftWith * (state: State, evaluate: func (card: Card): float): DraftResult {.inline.} =
  result = DraftResult(state: state)

  for card in state.me.hand:
    result.scores.add(card.evaluate)
