import streams
import strformat

import Input

type
  CardType * = enum
    creature,
    itemBlue,
    itemGreen,
    itemRed
  Card * = ref object
    attack *: int
    availableAttacks *: int # 0 - no attack; 1 - can Attack; -1 - already attacked
    cardDraw *: int
    cardNumber *: int
    cardType *: CardType
    cost *: int
    defense *: int
    hasBreakthrough *: bool
    hasCharge *: bool
    hasDrain *: bool
    hasGuard *: bool
    hasLethal *: bool
    hasWard *: bool
    instanceId *: int
    lane *: int
    location *: -1 .. 2
    myHealthChange *: int
    opHealthChange *: int

func `$` * (card: Card): string =
  var
    b = if card.hasBreakthrough: 'B' else: '-'
    c = if card.hasCharge:       'C' else: '-'
    d = if card.hasDrain:        'D' else: '-'
    g = if card.hasGuard:        'G' else: '-'
    l = if card.hasLethal:       'L' else: '-'
    w = if card.hasWard:         'W' else: '-'
  fmt"{card.instanceId:2} (#{card.cardNumber:3}:{card.cardType:>9}) {card.attack:2}/{card.defense:2} [{card.cost:2}] {b}{c}{d}{g}{l}{w}"

func evaluate1 * (card: Card): float =
  return
    (card.attack + card.defense) / (card.cost + 5) +
    (if card.hasBreakthrough: 0.1 else: 0) +
    (if card.hasCharge:       0.1 else: 0) +
    (if card.hasDrain:        0.1 else: 0) +
    (if card.hasGuard:        0.1 else: 0) +
    (if card.hasLethal:       0.1 else: 0) +
    (if card.hasWard:         0.1 else: 0)

proc toCard * (input: Stream): Card =
  var card = Card()
  card.cardNumber = input.getInt
  card.instanceId = input.getInt
  card.location = input.getInt

  var cardType = input.getInt
  if   cardType == 0: card.cardType = creature
  elif cardType == 1: card.cardType = itemGreen
  elif cardType == 2: card.cardType = itemRed
  elif cardType == 3: card.cardType = itemBlue

  card.cost = input.getInt
  card.attack = input.getInt
  card.defense = input.getInt

  var keywords = input.getStr
  card.hasBreakthrough = keywords[0] == 'B'
  card.hasCharge       = keywords[1] == 'C'
  card.hasDrain        = keywords[2] == 'D'
  card.hasGuard        = keywords[3] == 'G'
  card.hasLethal       = keywords[4] == 'L'
  card.hasWard         = keywords[5] == 'W'

  card.myHealthChange = input.getInt
  card.opHealthChange = input.getInt
  card.cardDraw = input.getInt
  card.lane = input.getInt
  card

when isMainModule:
  var a = "1 2 3 4 5 6 7 BCDG-- 8 9 10".newStringStream.toCard
  var b = "7 6 5 4 3 2 1 ----LW 0 0 11".newStringStream.toCard

  ($a & " " & (if a == b: "==" else: "!=") & " " & $b).echo
