import strscans

import Action
import Card
import Gamer

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
    for boardIndex, board in me.boards:
      for index, card in board:
        if card.instanceId == action.id1:
          attacker = card
          attackerBoard = boardIndex
          attackerIndex = index
          break

    var attackerAfter: Card
    shallowCopy(attackerAfter, attacker)
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
      for boardIndex, board in op.boards:
        for index, card in board:
          if card.instanceId == action.id1:
            defender = card
            defenderBoard = boardIndex
            defenderIndex = index
            break

      var defenderAfter: Card
      shallowCopy(defenderAfter, defender)

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
  for lane in 0 .. 1:
    if me.boards[lane].len < 6:
      for card in me.hand:
        if card.cardType != creature or card.cost > me.currentMana:
          continue
        result.add(Action(actionType: summon, id: card.instanceId, lane: lane))

  # ATTACH [id1] [id2]
  var targets: seq[int] = @[]
  for boardIndex, board in op.boards:
    for card in board:
      if card.hasGuard:
        targets.add(card.instanceId)
    if targets.len == 0:
      targets.add(-1)
      for card in board:
        targets.add(card.instanceId)
    for card in me.boards[boardIndex]:
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

func evaluateState * (state: State): float =
  var score = 0.0
  if state.op.health <= 0: score += 1000
  score += float(state.me.health - state.op.health) * 2
  score += float(state.me.boards[0].len - state.op.boards[0].len) * 1
  score += float(state.me.boards[1].len - state.op.boards[1].len) * 1
  var board = 0.0
  for card in state.me.boards[0]: board += float(card.attack + card.defense)
  for card in state.me.boards[1]: board += float(card.attack + card.defense)
  for card in state.op.boards[0]: board -= float(card.attack - card.defense)
  for card in state.op.boards[1]: board -= float(card.attack - card.defense)
  score += board * 0.5
  score
