import strformat
import strscans

import Card

type
  Gamer * = ref object
    board *: seq[Card]
    currentMana *: int
    decksize *: int
    hand *: seq[Card]
    handsize *: int
    health *: int
    maxMana *: int
    nextTurnDraw *: int
    rune *: int

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

func toGamer * (input: string): Gamer =
  var gamer = Gamer()
  if scanf(input, "$i $i $i $i", gamer.health, gamer.maxMana, gamer.decksize, gamer.rune):
    gamer.board = @[]
    gamer.currentMana = gamer.maxMana
    gamer.hand = @[]
    gamer.nextTurnDraw = 1
  gamer
