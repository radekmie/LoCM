import std / strformat
import Constants

type
  ActionType * = enum
    attack,
    pass,
    summon,
    use
  Action * = ref object
    text *: string
    case actionType *: ActionType
      of attack, use:
        id1  *: int
        id2  *: int
      of pass:
        discard
      of summon:
        id   *: int
        lane *: range[0 .. Lanes - 1]

func `$` * (action: Action): string =
  result = case action.actionType:
    of attack: &"ATTACK {action.id1} {action.id2}"
    of pass:   &"PASS"
    of summon: &"SUMMON {action.id} {action.lane}"
    of use:    &"USE {action.id1} {action.id2}"

  if action.text != "":
    result = &"{result} {action.text}"

when isMainModule:
  func main(): void =
    let x = Action(actionType: attack, id1: 1, id2: 2)
    let y = Action(actionType: attack, id1: 1, id2: 3, text: "GO")

    doAssert $x == "ATTACK 1 2"
    doAssert $y == "ATTACK 1 3 GO"

  main()