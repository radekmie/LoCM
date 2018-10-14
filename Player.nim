import os
import streams
import tables

import Card
import Draft
import Search
import State

var algorithms = newTable({
  "default": searchDepthFirst,
  "dfs":     searchDepthFirst,
  "noop":    searchNoop,
})

var evaluators = newTable({
  "default": draftEvaluateSimple,
  "noop":    draftEvaluateNoop,
  "simple":  draftEvaluateSimple,
})

var algorithm = algorithms["default"]
var evaluator = evaluators["default"]

if paramCount() > 0: algorithm = algorithms[paramStr(1)]
if paramCount() > 1: evaluator = evaluators[paramStr(2)]

var input = stdin.newFileStream
for turn in 1 .. 30:
  input.readState.evaluator.echo
for turn in 1 .. 256:
  input.readState.algorithm(190).echo
