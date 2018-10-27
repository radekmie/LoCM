import .. / .. / Engine / State

func evaluateStateSimple * (state: State): float =
  result = 100.0

  # Death.
  if state.op.health <= 0: result += 1000

  # Health diff.
  result += float(state.me.health - state.op.health) * 2

  for index in state.me.boards.low .. state.me.boards.high:
    # Card count.
    result += float(state.me.boards[index].len - state.op.boards[index].len)

    # Card strength.
    for card in state.me.boards[index]: result += float(card.attack + card.defense) * 0.5
    for card in state.op.boards[index]: result -= float(card.attack - card.defense) * 0.5
