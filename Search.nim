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
  if searchResult.actions.len == 0:
    "PASS"
  else:
    searchResult.actions.join(";")

proc searchDepthFirst * (state: State): SearchResult =
  var timeLimit = 90 / 1000
  var time = cpuTime()

  var states: array[16, State]
  var statesPointer = 0
  var legals: array[20, seq[Action]]
  var legalsPointers: array[16, int]

  states[0] = state
  legals[0] = state.computeActions(state.me, state.op)

  result = SearchResult(actions: legals[0], score: -999999, state: states[0])

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
