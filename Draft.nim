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

func draftEvaluateWith * (state: State, evaluate: func (card: Card): float): DraftResult {.inline.} =
  result = DraftResult(state: state)

  for card in state.me.hand:
    result.scores.add(card.evaluate)

func draftEvaluateClosetAI * (state: State): DraftResult =
  var scores = @[-666, 65, 50, 80, 50, 70, 71, 115, 71, 73, 43, 77, 62, 63, 50, 66, 60, 66, 90, 75, 50, 68, 67, 100, 42, 63, 67, 52, 69, 90, 60, 47, 87, 81, 67, 62, 75, 94, 56, 62, 51, 61, 43, 54, 97, 64, 67, 49, 109, 111, 89, 114, 93, 92, 89, 2, 54, 25, 63, 76, 58, 99, 79, 19, 82, 115, 106, 104, 146, 98, 70, 56, 65, 52, 54, 65, 55, 77, 48, 84, 115, 75, 89, 68, 80, 71, 46, 73, 69, 47, 63, 70, 11, 71, 54, 85, 77, 77, 64, 82, 62, 49, 43, 78, 67, 72, 67, 36, 48, 75, -8, 82, 69, 32, 87, 98, 124, 35, 60, 59, 49, 72, 54, 35, 22, 50, 54, 51, 54, 59, 38, 31, 43, 62, 55, 57, 41, 70, 38, 76, 1, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100, -100]
  state.draftEvaluateWith(func (card: Card): float = scores[card.cardNumber].float)

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
