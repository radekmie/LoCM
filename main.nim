import strformat
import strscans
import strutils

import Card
import State

func main(): void =
  for turn in 1 .. 30:
    var cardIndex: int
    var cardScore: float = -99999
    for index in 0 .. 2:
      var score = readCard().evaluate1
      if score > cardScore:
        cardIndex = index
        cardScore = score
    fmt"PICK {cardIndex}".echo
  while true:
    readState().depthFirstSearchOpt.join(";").echo
