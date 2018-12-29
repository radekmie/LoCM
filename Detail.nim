{.experimental: "parallel".}

import Engine / [Card, Cards, Config, Draft, State]
import Research / [IOHelpers, Referee]
import std / [
  ospaths,
  parseopt,
  random,
  re,
  sequtils,
  strformat,
  strutils,
  tables,
  threadpool
]

func toConfig (individual: array[160, float]): Config =
  let lookup = func (card: Card): float = individual[card.cardNumber - 1]

  result = newConfig(player = "Random")
  result.evalDraftFn = func (config: Config, state: State): DraftResult =
    state.evaluateDraftWith(lookup)

proc readBests (path: string, n: int = 5): seq[Config] =
  let text = toSeq(path.lines())
  let data = text[^n .. text.high]
  for line in data:
    var index = 0
    var params: array[160, float]
    for param in line.replacef(re"^.*\[(.*)\]$", "$1").split(", "):
      params[index] = parseFloat(param)
      index += 1

    result.add(params.toConfig)

proc main (): void =
  randomize()

  let cards = getCards()
  var drafts = newSeqWith(1, newDraft(cards))
  var players = toOrderedTable({
    "ClosetAI": @[newConfig(draft = "ClosetAI", player = "Random")],
    "Icebox": @[newConfig(draft = "Icebox", player = "Random")]
  })

  for kind, key, value in getOpt():
    if kind == cmdArgument:
      players[key.extractFilename().changeFileExt("")] = readBests(key)
    elif key == "drafts":
      drafts = newSeqWith(value.parseInt, newDraft(cards))

  var spans = newSeqWith(1 + players.len, 0)
  var table = @[@[""]]
  for x in players.keys:
    table[^1].add(x)
  table[^1].add("Average")

  for x, xs in players.pairs:
    table.add(@[x])

    var total: float
    for y, ys in players.pairs:
      echo &"# {stamp()} {x} vs {y}"

      if x == y:
        table[^1].add("-")
      else:
        var score: float
        let scoreWin = 100 / (2 * drafts.len * xs.len * ys.len).float

        for playerA in xs:
          for playerB in ys:
            parallel:
              for draft in drafts:
                let winA = spawn play(playerA, playerB, draft)
                let winB = spawn play(playerB, playerA, draft)
                if     winA: score += scoreWin
                if not winB: score += scoreWin

        table[^1].add(&"{score:.2f}%")
        total += score / (players.len - 1).float
    table[^1].add(&"{total:.2f}%")

  for row, cols in table:
    for col, text in cols:
      spans[col] = max(spans[col], text.len)

  for row, cols in table:
    for col, text in cols:
      table[row][col] = text.align(spans[col])

  echo table.mapIt(it.mapIt(it).join(" | ")).join("\n")

when isMainModule:
  main()
