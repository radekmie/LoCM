import strscans
import times

import Action
import Card
import Gamer

type
  State * = object
    me *: Gamer
    op *: Gamer
  StateResult * = object
    actions *: seq[Action]
    score   *: float
    state   *: State

func applyAction * (state: var State, action: Action, me, op: var Gamer): void =
  if action.actionType == summon:
    var card: Card
    for cardIndex, cardOnHand in me.hand:
      if cardOnHand.instanceId == action.id:
        card = cardOnHand
        me.hand.delete(cardIndex)
        me.handsize -= 1
        break

    card.availableAttacks = if card.hasCharge: 1 else: 0
    me.board.add(card)
    me.currentMana -= card.cost
    me.nextTurnDraw += card.cardDraw
    me.modifyHealth(card.myHealthChange)
    op.modifyHealth(card.opHealthChange)
    return

func applyMyAction * (state: var State, action: Action): void =
  state.applyAction(action, state.me, state.op)

func applyOpAction * (state: var State, action: Action): void =
  state.applyAction(action, state.op, state.me)

func computeActions * (state: State, me, op: Gamer): seq[Action] =
  # SUMMON [id]
  if (me.board.len < 6):
    for card in me.hand:
      if card.cardType != creature or card.cost > me.currentMana:
        continue
      result.add(Action(actionType: summon, id: card.instanceId))

  # ATTACH [id1] [id2]
  var targets: seq[int] = @[]
  for card in op.board:
    if card.hasGuard:
      targets.add(card.instanceId)
  if targets.len == 0:
    targets.add(-1)
    for card in op.board:
      targets.add(card.instanceId)
  for card in me.board:
    if card.availableAttacks != 1:
      continue
    for target in targets:
      result.add(Action(actionType: attack, id1: card.instanceId, id2: target))

  # USE [id1] [id2]
  for card in me.hand:
    if card.cardType == creature or card.cost > me.currentMana:
      continue
    if card.cardType == itemGreen:
      for creature in me.board:
        result.add(Action(actionType: use, id1: card.instanceId, id2: creature.instanceId))
    else:
      for creature in op.board:
        result.add(Action(actionType: use, id1: card.instanceId, id2: creature.instanceId))
      if card.cardType == itemBlue:
        result.add(Action(actionType: use, id1: card.instanceId, id2: -1))

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

proc searchDepthFirst * (state: State): StateResult =
  var timeLimit = 90 / 1000
  var time = cpuTime()

  var states: array[16, State]
  var statesPointer = 0
  var legals: array[20, seq[Action]]
  var legalsPointers: array[16, int]

  states[0] = state
  legals[0] = state.computeActions(state.me, state.op)

  result = StateResult(actions: legals[0], score: -999999, state: states[0])

  while true:
    if legalsPointers[statesPointer] >= legals[statesPointer].len:
      statesPointer -= 1
      if statesPointer < 0:
        break
      if statesPointer == 1 and cpuTime() - time > timeLimit:
        break
      legalsPointers[statesPointer] += 1
      continue

    statesPointer += 1
    states[statesPointer] = state
    states[statesPointer].applyMyAction(legals[statesPointer][legalsPointers[statesPointer]])
    legals[statesPointer] = states[statesPointer].computeActions(states[statesPointer].me, states[statesPointer].op)
    legalsPointers[statesPointer] = 0

    if legals[statesPointer].len == 0:
      var score = states[statesPointer].evaluateState
      if score > result.score:
        result.actions = @[]
        for index in 0 .. statesPointer:
          result.actions.add(legals[index][legalsPointers[index]])
        result.score = score
        result.state = state

        if score > 1000:
          break
