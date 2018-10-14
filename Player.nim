import os
import streams

import Card
import Draft
import Search
import State

var algorithm = searchDepthFirst
var evaluator = draftEvaluate1

var input = stdin.newFileStream
for turn in 1 .. 30:
  input.readState.evaluator.echo
for turn in 1 .. 256:
  input.readState.algorithm(190).echo
