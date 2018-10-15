import random
import strformat
import strutils
import times

import Action
import State

type
  SearchResult * = ref object
    actions *: seq[Action]
    score   *: float
    state   *: State

func `$` * (searchResult: SearchResult): string =
  result = if searchResult.actions.len == 0: "PASS" else: searchResult.actions.join(";")
  result = fmt"{result} # score: {searchResult.score}"

proc simulate * (root: State): SearchResult =
  var state = root.copy
  var legals = state.computeActions(state.me, state.op)
  var actions: seq[Action] = @[]

  while legals.len > 0:
    let action = legals.rand
    actions.add(action)
    state.applyMyAction(action)
    legals = state.computeActions(state.me, state.op)

  SearchResult(actions: actions, score: state.evaluateState, state: state)

proc searchDepthFirst * (state: State, timeLimit: float): SearchResult =
  result = SearchResult(actions: @[], score: 0, state: state)

  let time = cpuTime()

  var states: array[16, State]
  var statesPointer = 0
  var legals: array[20, seq[Action]]
  var legalsPointers: array[16, int]

  states[0] = state
  legals[0] = state.computeActions(state.me, state.op)

  while cpuTime() - time < timeLimit:
    when not defined(release):
      stderr.writeLine("")
      stderr.writeLine("result: ", result, " statesPointer: ", statesPointer)
      stderr.writeLine("A:      ", legalsPointers[statesPointer])
      stderr.writeLine("B:      ", legals[statesPointer].len, " ", legals[statesPointer])

    if legalsPointers[statesPointer] >= legals[statesPointer].len:
      statesPointer -= 1
      if statesPointer < 0:
        break
      legalsPointers[statesPointer] += 1
      continue

    var next = states[statesPointer].copy
    next.applyMyAction(legals[statesPointer][legalsPointers[statesPointer]])

    statesPointer += 1
    states[statesPointer] = next
    legals[statesPointer] = next.computeActions(next.me, next.op)
    legalsPointers[statesPointer] = 0

    if legals[statesPointer].len == 0:
      let score = states[statesPointer].evaluateState
      if score > result.score:
        result.actions = @[]
        for index in 0 .. statesPointer - 1:
          result.actions.add(legals[index][legalsPointers[index]])
        result.score = score
        result.state = state

        if score > 1000:
          break

proc searchFlatMontoCarlo * (state: State, timeLimit: float): SearchResult =
  result = SearchResult(actions: @[], score: 0, state: state)

  let time = cpuTime()

  while cpuTime() - time < timeLimit:
    let simulated = state.simulate
    if simulated.score > result.score:
      result = simulated

proc searchNoop * (state: State, timeLimit: float): SearchResult =
  result = SearchResult(actions: @[], score: 0, state: state)
