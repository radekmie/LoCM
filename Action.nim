import strformat

type
  ActionType * = enum
    attack,
    summon,
    use
  Action * = object
    text *: string
    case actionType *: ActionType
      of attack, use:
        id1 *: int
        id2 *: int
      of summon:
        id *: int

func `$` * (action: Action): string =
  case action.actionType:
    of attack:
      result = fmt"ATTACK {action.id1} {action.id2}"
    of summon:
      result = fmt"SUMMON {action.id}"
    of use:
      result = fmt"USE {action.id1} {action.id2}"

  if action.text != "":
    result = fmt"{result} {action.text}"

func `==` * (a, b: Action): bool =
  if a.actionType != b.actionType: return false
  if a.actionType == attack or a.actionType == use:
    a.id1 == b.id1 and a.id2 == b.id2 and a.text == b.text
  else:
    a.id == b.id and a.text == b.text

when isMainModule:
  var x = Action(actionType: attack, id1: 1, id2: 2)
  var y = Action(actionType: attack, id1: 1, id2: 3, text: "GO")
  doAssert $x == "ATTACK 1 2"
  doAssert $y == "ATTACK 1 3 GO"
  doAssert x != y
