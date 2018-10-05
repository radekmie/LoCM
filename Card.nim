import strformat
import strscans

type
  CardType * = enum
    creature,
    itemBlue,
    itemGreen,
    itemRed
  Card * = object
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
    location *: int
    myHealthChange *: int
    oppHealthChange *: int

func `$` * (card: Card): string =
  var
    b = if card.hasBreakthrough: 'B' else: '-'
    c = if card.hasCharge:       'C' else: '-'
    d = if card.hasDrain:        'D' else: '-'
    g = if card.hasGuard:        'G' else: '-'
    l = if card.hasLethal:       'L' else: '-'
    w = if card.hasWard:         'W' else: '-'
  fmt"{card.instanceId:02} (#{card.cardNumber:03}:{card.cardType:>9}) {card.attack:2}/{card.defense:2} [{card.cost:2}] {b}{c}{d}{g}{l}{w}"

func evaluate1 * (card: Card): float =
  return
    (card.attack + card.defense) / (card.cost + 5) +
    (if card.hasBreakthrough: 0.1 else: 0) +
    (if card.hasCharge:       0.1 else: 0) +
    (if card.hasDrain:        0.1 else: 0) +
    (if card.hasGuard:        0.1 else: 0) +
    (if card.hasLethal:       0.1 else: 0) +
    (if card.hasWard:         0.1 else: 0)

func toCard * (input: string): Card =
  var card = Card()
  var cardType: int
  var keywords: string
  if scanf(input, "$i $i $i $i $i $i $i $* $i $i $i$.", card.cardNumber, card.instanceId, card.location, cardType, card.cost, card.attack, card.defense, keywords, card.myHealthChange, card.oppHealthChange, card.cardDraw):
    if   cardType == 0: card.cardType = creature
    elif cardType == 1: card.cardType = itemGreen
    elif cardType == 2: card.cardType = itemRed
    elif cardType == 3: card.cardType = itemBlue

    card.hasBreakthrough = keywords[0] == 'B'
    card.hasCharge       = keywords[1] == 'C'
    card.hasDrain        = keywords[2] == 'D'
    card.hasGuard        = keywords[3] == 'G'
    card.hasLethal       = keywords[4] == 'L'
    card.hasWard         = keywords[5] == 'W'
  card

when isMainModule:
  var a = "1 2 3 4 5 6 7 BCDG-- 8 9 10".toCard
  var b = "0 0 0 0 0 0 0 ----LW 0 0 11".toCard

  ($a & " " & (if a == b: "==" else: "!=") & " " & $b).echo
