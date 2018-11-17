import std / [parseopt, random, sequtils, strformat, strutils, tables, times]
import Engine / [Action, Card, Cards, Config, Draft, Gamer, Search, State]
import Research / [
  IOHelpers,
  DraftEvaluations / AllDraftEvaluations,
  PlayerAlgorithms / AllPlayerAlgorithms,
  StateEvaluations / AllStateEvaluations,
]

type
  Options = tuple[
    games:   int,
    verbose: bool
  ]

proc doDraw (gamer: var Gamer, deck: var seq[Card], turn: int): void =
  let suicide = turn > 50
  for _ in 1 .. gamer.nextTurnDraw:
    if gamer.decksize == 0 or suicide:
      gamer.modifyHealth(gamer.rune - gamer.health)
      if not suicide:
        continue

    if gamer.handsize == 8:
      break

    gamer.hand.add(deck.pop)
    gamer.handsize += 1
    gamer.decksize -= 1
  gamer.nextTurnDraw = 1

proc getOptions (): Options =
  var games = 0
  var verbose = true

  for kind, key, value in getOpt():
    if key == "games":   result.games   = value.parseInt
    if key == "verbose": result.verbose = value.parseBool

proc play * (a, b: Config, draft: Draft, verbose: bool = false): bool =
  var state = newState()
  var deck1: seq[Card]
  var deck2: seq[Card]

  for turn in 1 .. 30:
    for card in draft[turn - 1]:
      state.me.hand.add(card.copy)

    let pick1 = a.evalDraft(state)
    let pick2 = b.evalDraft(state)

    deck1.add(state.me.hand[pick1.index].copy)
    deck2.add(state.me.hand[pick2.index].copy)

    state.me.decksize += 1
    state.op.decksize += 1

    if verbose:
      echo &"{stamp()} Draft {turn}"
      echo &"{stamp()} 1? {state.me.hand[0]}"
      echo &"{stamp()} 2? {state.me.hand[1]}"
      echo &"{stamp()} 3? {state.me.hand[2]}"
      echo &"{stamp()} 1! {pick1}"
      echo &"{stamp()} 2! {pick2}"

    state.me.hand.setLen(0)

  for i in countdown(29, 1):
    let j = rand(i)
    swap(deck1[i], deck1[j])
    swap(deck2[i], deck2[j])

  for id, card in deck1: card.instanceId = (30 - id) * 2 - 1
  for id, card in deck2: card.instanceId = (30 - id) * 2

  if verbose:
    echo &"{stamp()} Cards"
    for index in countdown(60, 1):
      let player = (index - 1) mod 2
      let card = (if player == 1: deck1 else: deck2)[(index - 1) div 2]
      echo &"{stamp()} {2 - player}? {card}"

  for card in 1 .. 3:
    doDraw(state.me, deck1, 0)
    doDraw(state.op, deck2, 0)
  doDraw(state.op, deck2, 0)

  block loop:
    for turn in 1 .. 256:
      state.rechargeMana(turn)
      state.rechargeCreatures

      if verbose:
        echo &"{stamp()} Turn {turn:<12} # [{state.me}] [{state.op}]"

      for action in a.play(state).actions:
        state.applyAction(action)
        if verbose:
          echo &"{stamp()} 1! {action:14} # [{state.me}] [{state.op}]"
        if state.isGameOver:
          break loop

      state = state.swap

      for action in b.play(state).actions:
        state.applyAction(action)
        if verbose:
          echo &"{stamp()} 2! {action:14} # [{state.op}] [{state.me}]"
        if state.isGameOver:
          state = state.swap
          break loop

      state = state.swap

      doDraw(state.me, deck1, turn)
      doDraw(state.op, deck2, turn)

  if verbose:
    echo &"{stamp()} End               # [{state.me}] [{state.op}]"

  return state.me.health > 0

proc main (): void =
  var cards = getCards()
  var draft: Draft
  let (games, verbose) = getOptions()
  let player1 = getConfig("p1-")
  let player2 = getConfig("p2-")
  var wins1 = 0
  var wins2 = 0

  randomize()

  for game in 1 .. games:
    # FIXME: Implement draft from options
    cards.shuffle
    for pick in 0 ..< 30:
      for index in 0 ..< 3:
        draft[pick][index] = cards[pick * 3 + index]

    if play(player1, player2, draft, verbose):
      wins1 += 1
    else:
      wins2 += 1

    let proc1 = 100 * wins1 / game
    let proc2 = 100 * wins2 / game
    echo &"{stamp()} Stats {game:>3}: {proc1:6.2f}% {proc2:6.2f}%"

when isMainModule:
  main()
