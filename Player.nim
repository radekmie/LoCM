import os
import streams
import strutils
import tables

import Card
import Draft
import Search
import State

when isMainModule:
  proc main(): void =
    var algorithms = newTable({
      "default":        searchDepthFirst,
      "dfs":            searchDepthFirst,
      "flatMonteCarlo": searchFlatMontoCarlo,
      "noop":           searchNoop,
    })

    var evaluators = newTable({
      "default":  draftEvaluateSimple,
      "closetAI": draftEvaluateClosetAI,
      "icebox":   draftEvaluateIcebox,
      "noop":     draftEvaluateNoop,
      "simple":   draftEvaluateSimple,
    })

    var algorithm = algorithms["default"]
    var evaluator = evaluators["default"]
    var timeLimit = 190.float

    if paramCount() > 0: algorithm = algorithms[paramStr(1)]
    if paramCount() > 1: evaluator = evaluators[paramStr(2)]
    if paramCount() > 2: timeLimit = paramStr(3).parseInt.float

    # NOTE: cpuTime is in seconds.
    timeLimit = timeLimit / 1000

    var input = stdin.newFileStream
    for turn in 1 .. 30:
      input.readState.evaluator.echo
    for turn in 1 .. 256:
      input.readState.algorithm(timeLimit).echo

  main()
