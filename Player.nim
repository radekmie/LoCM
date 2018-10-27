import std / [parseopt, streams, strutils, tables]
import Engine / [Config, Draft, Input, Search, State]
import Research / [
  DraftEvaluations / AllDraftEvaluations,
  PlayerAlgorithms / AllPlayerAlgorithms,
  StateEvaluations / AllStateEvaluations,
]

proc readConfig (): Config =
  result = Config(
    evaluateDraft: draftEvaluations["default"],
    evaluateState: stateEvaluations["default"],
    playAlgorithm: playerAlgorithms["default"],
    seed: 0,
    time: 190.0
  )

  for kind, key, value in getOpt():
    case kind:
      of cmdLongOption, cmdShortOption:
        case key:
          of "draft":  result.evaluateDraft = draftEvaluations[value]
          of "player": result.playAlgorithm = playerAlgorithms[value]
          of "state":  result.evaluateState = stateEvaluations[value]
          of "seed":   result.seed = value.parseInt
          of "time":   result.time = value.parseFloat
          else: discard
      else: discard

when isMainModule:
  proc main(): void =
    let config = readConfig()
    let eval = config.eval
    let play = config.play

    var input = stdin.newFileStream.newInput
    for turn in 1 .. 30: echo input.readState.eval
    for turn in 1 .. 99: echo input.readState.play

  main()
