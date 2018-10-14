import streams
import strformat

import Action
import Card
import Gamer
import Input

type
  State * = ref object
    me *: Gamer
    op *: Gamer

func applyAction * (state: var State, action: Action, me, op: var Gamer): void =
  case action.actionType:
  of attack:
    var attacker: Card
    var attackerBoard: int
    var attackerIndex: int
    for lane, board in me.boards:
      for index, card in board:
        if card.instanceId == action.id1:
          attacker = card
          attackerBoard = lane
          attackerIndex = index
          break

    var attackerAfter = attacker.copy
    attackerAfter.availableAttacks = -1

    if action.id2 == -1:
      if attacker.hasDrain:
        me.modifyHealth(attacker.attack)
      op.modifyHealth(-attacker.attack)
      me.boards[attackerBoard][attackerIndex] = attackerAfter
    else:
      var defender: Card
      var defenderBoard: int
      var defenderIndex: int
      for lane, board in op.boards:
        for index, card in board:
          if card.instanceId == action.id2:
            defender = card
            defenderBoard = lane
            defenderIndex = index
            break

      var defenderAfter = defender.copy

      if defender.hasWard: defenderAfter.hasWard = attacker.attack == 0
      if attacker.hasWard: attackerAfter.hasWard = defender.attack == 0

      var damageGiven = if defender.hasWard: 0 else: attacker.attack
      var damageTaken = if attacker.hasWard: 0 else: defender.attack
      var healthGain  = 0
      var healthTaken = 0

      # attacking
      if damageGiven >= defender.defense: defenderAfter = nil
      if attacker.hasBreakthrough and defenderAfter == nil: healthTaken = defender.defense - damageGiven
      if attacker.hasLethal and damageGiven > 0: defenderAfter = nil
      if attacker.hasDrain and damageGiven > 0: healthGain = attacker.attack
      if defenderAfter != nil: defenderAfter.defense -= damageGiven

      # defending
      if damageTaken >= attacker.defense: attackerAfter = nil
      if defender.hasLethal and damageTaken > 0: attackerAfter = nil
      if attackerAfter != nil: attackerAfter.defense -= damageTaken

      if attackerAfter == nil:
        me.boards[attackerBoard].delete(attackerIndex)
      else:
        me.boards[attackerBoard][attackerIndex] = attackerAfter

      if defenderAfter == nil:
        op.boards[defenderBoard].delete(defenderIndex)
      else:
        op.boards[defenderBoard][defenderIndex] = defenderAfter

      me.modifyHealth(healthGain)
      op.modifyHealth(healthTaken)
  of summon:
    var card: Card
    for cardIndex, cardOnHand in me.hand:
      if cardOnHand.instanceId == action.id:
        card = cardOnHand
        me.hand.delete(cardIndex)
        me.handsize -= 1
        break

    card.availableAttacks = if card.hasCharge: 1 else: 0
    me.boards[action.lane].add(card)
    me.currentMana -= card.cost
    me.nextTurnDraw += card.cardDraw
    me.modifyHealth(card.myHealthChange)
    op.modifyHealth(card.opHealthChange)
  of use:
    discard 1

func applyMyAction * (state: var State, action: Action): void =
  state.applyAction(action, state.me, state.op)

func applyOpAction * (state: var State, action: Action): void =
  state.applyAction(action, state.op, state.me)

func computeActions * (state: State, me, op: Gamer): seq[Action] =
  # SUMMON [id] [lane]
  for lane, board in me.boards:
    if board.len < 3:
      for card in me.hand:
        if card.cardType != creature or card.cost > me.currentMana:
          continue
        result.add(Action(actionType: summon, id: card.instanceId, lane: lane))

  # ATTACH [id1] [id2]
  for lane, board in op.boards:
    var targets: seq[int] = @[]
    for card in board:
      if card.hasGuard:
        targets.add(card.instanceId)

    if targets.len == 0:
      targets.add(-1)
      for card in board:
        targets.add(card.instanceId)

    for card in me.boards[lane]:
      if card.availableAttacks != 1:
        continue
      for target in targets:
        result.add(Action(actionType: attack, id1: card.instanceId, id2: target))

  # USE [id1] [id2]
  # TODO: Implement use actions in applyAction.
  # for card in me.hand:
  #   if card.cardType == creature or card.cost > me.currentMana:
  #     continue
  #   if card.cardType == itemGreen:
  #     for board in me.boards:
  #       for creature in board:
  #         result.add(Action(actionType: use, id1: card.instanceId, id2: creature.instanceId))
  #   else:
  #     for board in op.boards:
  #       for creature in board:
  #         result.add(Action(actionType: use, id1: card.instanceId, id2: creature.instanceId))
  #     if card.cardType == itemBlue:
  #       result.add(Action(actionType: use, id1: card.instanceId, id2: -1))

func copy * (state: State): State =
  deepCopy(result, state)

func evaluateState * (state: State): float =
  result = 0.0

  # Death.
  if state.op.health <= 0: result += 1000

  # Health diff.
  result += float(state.me.health - state.op.health) * 2

  for index in state.me.boards.low .. state.me.boards.high:
    # Card count.
    result += float(state.me.boards[index].len - state.op.boards[index].len)

    # Card strength.
    for card in state.me.boards[index]: result += float(card.attack + card.defense) * 0.5
    for card in state.op.boards[index]: result -= float(card.attack - card.defense) * 0.5

proc readState * (input: Stream): State =
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
      of 0:
        state.me.hand.add(card)
      of 1:
        card.availableAttacks = 1
        state.me.boards[card.lane].add(card)
      of -1:
        state.op.boards[card.lane].add(card)

  state.me.handsize = state.me.hand.len
  state
