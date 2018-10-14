import strformat

import Card
import State

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

  fmt"PICK {bestIndex} # score: {bestScore}"

func draftEvaluateWith * (state: State, evaluate: func (card: Card): float): DraftResult =
  result = DraftResult(scores: @[], state: state)

  for card in state.me.hand:
    result.scores.add(card.evaluate)

func draftEvaluateNoop * (state: State): DraftResult =
  state.draftEvaluateWith(func (card: Card): float = 0)

func draftEvaluateSimple * (state: State): DraftResult =
  state.draftEvaluateWith(func (card: Card): float =
    return
      (card.attack + card.defense) / (card.cost + 5) +
      (if card.hasBreakthrough: 0.1 else: 0) +
      (if card.hasCharge:       0.1 else: 0) +
      (if card.hasDrain:        0.1 else: 0) +
      (if card.hasGuard:        0.1 else: 0) +
      (if card.hasLethal:       0.1 else: 0) +
      (if card.hasWard:         0.1 else: 0)
  )
