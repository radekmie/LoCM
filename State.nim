import strscans

import Action
import Card
import Gamer

type
  State * = object
    me *: Gamer
    op *: Gamer

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

func depthFirstSearchOpt * (state: State): seq[Action] =
  @[]

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
