import strscans

import Action
import Card
import Gamer

type
  State * = object
    me *: Gamer
    op *: Gamer

func computeActions * (state: State): seq[Action] =
  @[]

func depthFirstSearchOpt * (state: State): seq[Action] =
  @[]

func evaluateState * (state: State): float =
  var score = 0.0
  if state.op.health <= 0: score += 1000
  score += float(state.me.health - state.op.health) * 2
  score += float(state.me.board.len - state.op.board.len) * 1
  var board = 0.0
  for card in state.me.board: board += float(card.attack + card.defense)
  for card in state.op.board: board -= float(card.attack - card.defense)
  score += board * 0.5
  score

func readState * (): State =
  var state = State()
  state.me = stdin.readline.toGamer
  var line = stdin.readline
  state.op = line.toGamer

  var x: int
  var cardCount: int
  if scanf(line, "$i $i $i $i $i $i", x, x, x, x, state.op.handsize, cardCount):
    for index in 1 .. cardCount:
      var card = stdin.readline.toCard
      if card.location == 0:
        state.me.hand.add(card)
      if card.location == 1:
        card.availableAttacks = 1
        state.me.board.add(card)
      if card.location == 2:
        state.op.board.add(card)
    state.me.handsize = state.me.hand.len
  state
