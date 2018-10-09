import strformat
import strscans
import strutils

import Card
import Gamer
import State

proc readDraft (): array[3, Card] =
  [
    stdin.readline.toCard,
    stdin.readline.toCard,
    stdin.readline.toCard
  ]

proc readState (): State =
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

proc doDraft (): void =
  var cards = readDraft()
  var cardIndex: int
  var cardScore: float = -99999
  for index in 0 .. 2:
    var score = stdin.readline.toCard.evaluate1
    if score > cardScore:
      cardIndex = index
      cardScore = score
  fmt"PICK {cardIndex}".echo

proc doTurn (): void =
  readState().searchDepthFirst.actions.join(";").echo

when isMainModule:
  for turn in 1 .. 30:
    doDraft()
  while true:
    doTurn()
