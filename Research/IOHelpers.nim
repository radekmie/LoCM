import std / [parseopt, streams, strformat, strutils, tables, times]
import DraftEvaluations / AllDraftEvaluations
import PlayerAlgorithms / AllPlayerAlgorithms
import StateEvaluations / AllStateEvaluations
import .. / Engine / [Config, Input]

proc getConfig * (p: string = ""): Config =
  result = Config(
    evalDraftFn: draftEvaluations["default"],
    evalStateFn: stateEvaluations["default"],
    playFn:      playerAlgorithms["default"],
    time:      190.0 / 1000,
  )

  for kind, key, value in getOpt():
    if key == p & "draft":  result.evalDraftFn = draftEvaluations[value]
    if key == p & "player": result.playFn      = playerAlgorithms[value]
    if key == p & "state":  result.evalStateFn = stateEvaluations[value]
    if key == p & "time":   result.time      = value.parseFloat / 1000

proc getInput * (): Input =
  stdin.newFileStream.newInput

proc stamp * (): string =
  now().format("yyyy-MM-dd' 'HH:mm:ss'.'fff")
