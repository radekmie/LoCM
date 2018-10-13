import streams
import strformat
import strscans

import Action
import Card
import Gamer
import Input
import Search
import State

proc readState (input: Stream): State =
  var state = State()
  state.me = input.toGamer
  state.op = input.toGamer
  state.op.handsize = input.getInt

  # Skip opponent actions.
  for index in 1 .. input.getInt:
    discard input.getLine

  for index in 1 .. input.getInt:
    var card = input.toCard
    case card.location:
    of -1, 0:
      state.me.hand.add(card)
    of 1:
      card.availableAttacks = 1
      state.me.boards[card.lane].add(card)
    of 2:
      state.op.boards[card.lane].add(card)

  state.me.handsize = state.me.hand.len
  state

proc doDraft (input: Stream): void =
  var state = input.readState
  var cardIndex: int
  var cardScore: float = -99999
  for index, card in state.me.hand:
    var score = card.evaluate1
    if score > cardScore:
      cardIndex = index
      cardScore = score
  fmt"PICK {cardIndex} #score: {cardScore}".echo

proc doTurn (input: Stream): void =
  input.readState.searchDepthFirst.echo

when isMainModule:
  var input = stdin.newFileStream
  for turn in 1 .. 30:
    when not defined(release):
      stderr.writeLine("TURN: ", turn)
    input.doDraft
  for turn in 1 .. 256:
    when not defined(release):
      stderr.writeLine("TURN: ", turn)
    input.doTurn
