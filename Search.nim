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
    result = "PASS"
  else:
    result = searchResult.actions.join(";")
  result.add(" # score: ")
  result.add(searchResult.score)

proc searchDepthFirst * (state: State, timeLimitMs: int): SearchResult =
  result = SearchResult(actions: @[], score: 0, state: state)

  var timeLimit = timeLimitMs / 100000
  var time = cpuTime()

  var states: array[16, State]
  var statesPointer = 0
  var legals: array[20, seq[Action]]
  var legalsPointers: array[16, int]

  states[0] = state
  legals[0] = state.computeActions(state.me, state.op)

  while true:
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

    if cpuTime() - time > timeLimit:
      break

    var next = states[statesPointer].copy
    next.applyMyAction(legals[statesPointer][legalsPointers[statesPointer]])

    statesPointer += 1
    states[statesPointer] = next
    legals[statesPointer] = next.computeActions(next.me, next.op)
    legalsPointers[statesPointer] = 0

    if legals[statesPointer].len == 0:
      var score = states[statesPointer].evaluateState
      if score > result.score:
        result.actions = @[]
        for index in 0 .. statesPointer - 1:
          result.actions.add(legals[index][legalsPointers[index]])
        result.score = score
        result.state = state

        if score > 1000:
          break

proc searchNoop * (state: State, timeLimitMs: int): SearchResult =
  result = SearchResult(actions: @[], score: 0, state: state)
