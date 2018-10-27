import .. / .. / Engine / [Card, Draft, State]

func evaluateDraftIcebox * (state: State): DraftResult =
  state.evaluateDraftWith(func (card: Card): float =
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
