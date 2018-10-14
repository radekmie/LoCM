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

func draftEvaluateIcebox * (state: State): DraftResult =
  state.draftEvaluateWith(func (card: Card): float =
    return
      (card.attack.float + card.defense.float) -
      (6.392651 * 0.001 * card.cost.float * card.cost.float + 1.463006 * card.cost.float + 1.435985) + 5.219 -
      (-5.985350469 * 0.01 * (card.myHealthChange.float - card.opHealthChange.float) * (card.myHealthChange.float - card.opHealthChange.float) - 3.880957 * 0.1 * (card.myHealthChange.float - card.opHealthChange.float) + 1.63766 * 0.1) -
      (5.516179907 * card.cardDraw.float * card.cardDraw.float - 0.239521 * card.cardDraw.float + 7.751401869 * 0.01) +
      (if card.hasBreakthrough: 0.0 else: 0) +
      (if card.hasCharge:       0.26015517 else: 0) +
      (if card.hasDrain:        0.15241379 else: 0) +
      (if card.hasGuard:        0.04418965 else: 0) +
      (if card.hasLethal:       0.15313793 else: 0) +
      (if card.hasWard:         0.16238793 else: 0)
  )

func draftEvaluateNoop * (state: State): DraftResult =
  state.draftEvaluateWith(func (card: Card): float = 0)

func draftEvaluateSimple * (state: State): DraftResult =
  state.draftEvaluateWith(func (card: Card): float =
    return
      (card.attack + card.defense) / (card.cost + 5) +
      (if card.hasBreakthrough: 0.1 else: 0) +
      (if card.hasCharge:       0.2 else: 0) +
      (if card.hasDrain:        0.2 else: 0) +
      (if card.hasGuard:        0.4 else: 0) +
      (if card.hasLethal:       0.3 else: 0) +
      (if card.hasWard:         0.2 else: 0)
  )
