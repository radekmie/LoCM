import parseopt
import streams
import strutils
import tables

import Card
import Draft
import Input
import Search
import State

when isMainModule:
  proc main(): void =
    let algorithms = newTable({
      "default":        searchDepthFirst,
      "dfs":            searchDepthFirst,
      "flatMonteCarlo": searchFlatMontoCarlo,
      "noop":           searchNoop,
    })

    let evaluators = newTable({
      "default":  draftEvaluateSimple,
      "closetAI": draftEvaluateClosetAI,
      "icebox":   draftEvaluateIcebox,
      "noop":     draftEvaluateNoop,
      "simple":   draftEvaluateSimple,
    })

    var algorithmInput = "default"
    var evaluatorInput = "default"
    var timeLimitInput = 190.float

    for kind, key, value in getOpt():
      case kind:
        of cmdLongOption, cmdShortOption:
          case key:
            of "algorithm": algorithmInput = value
            of "evaluator": evaluatorInput = value
            of "timeLimit": timeLimitInput = value.parseFloat
            else: discard
        else: discard

    let algorithm = algorithms[algorithmInput]
    let evaluator = evaluators[evaluatorInput]
    let timeLimit = timeLimitInput / 1000

    var input = stdin.newFileStream.newInput
    for turn in 1 .. 30:
      input.readState.evaluator.echo
    for turn in 1 .. 256:
      input.readState.algorithm(timeLimit).echo

  main()
