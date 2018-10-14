import streams
import strformat

import Card
import Input

type
  Gamer * = ref object
    boards       *: array[2, seq[Card]]
    currentMana  *: int
    decksize     *: int
    hand         *: seq[Card]
    handsize     *: int
    health       *: int
    maxMana      *: int
    nextTurnDraw *: int
    rune         *: int

func modifyHealth * (gamer: var Gamer, diff: int): void =
  gamer.health += diff

  if diff >= 0:
    return

  while gamer.health <= gamer.rune:
    gamer.nextTurnDraw += 1
    gamer.rune -= 5
    if gamer.rune <= 0:
      break

func `$` * (gamer: Gamer): string =
  fmt"{gamer.health:02} ({gamer.rune}) HP  {gamer.currentMana:02}/{gamer.maxMana:02} MP  {gamer.decksize} D (+{gamer.nextTurnDraw})"

proc toGamer * (input: Stream): Gamer =
  var gamer = Gamer()
  gamer.health = input.getInt
  gamer.maxMana = input.getInt
  gamer.decksize = input.getInt
  gamer.rune = input.getInt
  gamer.nextTurnDraw = input.getInt
  for index in gamer.boards.low .. gamer.boards.high:
    gamer.boards[index] = @[]
  gamer.currentMana = gamer.maxMana
  gamer.hand = @[]
  gamer
