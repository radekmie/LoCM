import streams
import strformat

import Card
import Constants
import Input

type
  Gamer * = ref object
    boards       *: array[Lanes, seq[Card]]
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

  while gamer.health <= gamer.rune:
    gamer.nextTurnDraw += 1
    gamer.rune -= 5
    if gamer.rune <= 0:
      break

func `$` * (gamer: Gamer): string =
  fmt"{gamer.health:2} ({gamer.rune}) HP  {gamer.currentMana:2}/{gamer.maxMana:2} MP  {gamer.decksize:2} D (+{gamer.nextTurnDraw})"

proc toGamer * (input: Stream): Gamer =
  var gamer = Gamer()

  gamer.health       = input.getInt
  gamer.maxMana      = input.getInt
  gamer.decksize     = input.getInt
  gamer.rune         = input.getInt
  gamer.nextTurnDraw = input.getInt

  for index in gamer.boards.low .. gamer.boards.high:
    gamer.boards[index] = @[]

  gamer.currentMana = gamer.maxMana
  gamer.hand        = @[]
  gamer
