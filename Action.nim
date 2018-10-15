import strformat

import Constants

type
  ActionType * = enum
    attack,
    summon,
    use
  Action * = ref object
    text *: string
    case actionType *: ActionType
      of attack, use:
        id1  *: int
        id2  *: int
      of summon:
        id   *: int
        lane *: range[0 .. Lanes - 1]

func `$` * (action: Action): string =
  result = case action.actionType:
    of attack: fmt"ATTACK {action.id1} {action.id2}"
    of summon: fmt"SUMMON {action.id} {action.lane}"
    of use:    fmt"USE {action.id1} {action.id2}"

  if action.text != "":
    result = fmt"{result} {action.text}"

when isMainModule:
  func main(): void =
    let x = Action(actionType: attack, id1: 1, id2: 2)
    let y = Action(actionType: attack, id1: 1, id2: 3, text: "GO")

    doAssert $x == "ATTACK 1 2"
    doAssert $y == "ATTACK 1 3 GO"

  main()
