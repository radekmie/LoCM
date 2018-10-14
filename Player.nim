import streams

import Card
import Search
import State

when isMainModule:
  var input = stdin.newFileStream
  for turn in 1 .. 30:
    input.readState.evaluateDraft(evaluate1).echo
  for turn in 1 .. 256:
    input.readState.searchDepthFirst(190).echo
