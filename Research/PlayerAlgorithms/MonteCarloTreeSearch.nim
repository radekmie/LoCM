import std / [math, random, strformat, strutils, times]
import .. / .. / Engine / [Action, Config, Search, State]

const
  EXPLORATION = sqrt(2.0)

type
  Node = ref object
    # Info.
    move   *: Action
    nodes  *: seq[Node]
    opened *: bool
    parent *: Node
    state  *: State

    # Stats.
    point *: float
    visit *: float

func propagate (node: Node, score: float): void =
  node.point += score
  node.visit += 1

  if node.parent != nil:
    node.parent.propagate(score)

func evaluate (node: Node, config: Config): void {.inline.} =
  node.propagate(config.evaluateState(node.state))

func score (node: Node): float {.inline.} =
  if node.visit < 1:
    return 9999

  result = node.point / node.visit
  if node.parent != nil:
    result += EXPLORATION * sqrt(ln(node.parent.visit) / node.visit)

func pick (node: Node): Node =
  if node.nodes.len == 0:
    return nil

  var bestIndex = 0
  var bestScore = 0.0

  for index in node.nodes.low .. node.nodes.high:
    let score = node.nodes[index].score
    if score > bestScore:
      bestIndex = index
      bestScore = score

  node.nodes[bestIndex]

func run (node: Node, config: Config): void =
  let wasExpanding = not node.opened
  if wasExpanding:
    node.nodes = @[]
    node.opened = true

    for action in node.state.computeActions:
      var state = node.state.copy
      state.applyMyAction(action)
      node.nodes.add(Node(move: action, parent: node, state: state))

  if node.nodes.len == 0:
    node.evaluate(config)
  elif wasExpanding:
    node.pick.evaluate(config)
  else:
    node.pick.run(config)

func toSearchResult (node: Node): SearchResult =
  var actions: seq[Action]
  var root = node
  while true:
    if root.move != nil:
      actions.add(root.move)
    let next = root.pick
    if next == nil:
      break
    root = next
  SearchResult(actions: actions, score: root.score, state: root.state)

func `$` (node: Node): string =
  let move = if node.move == nil: "nil" else: $node.move
  result = &"Node(move:{move},score:{node.score},opened:{node.opened},point:{node.point},visit:{node.visit},nodes:{node.nodes})"

func playerAlgorithmMonteCarloTreeSearch * (config: Config): proc (state: State): SearchResult =
  return proc (state: State): SearchResult =
    var root = Node(state: state)
    let time = cpuTime()

    while cpuTime() - time < config.time:
      for _ in 1 .. 100:
        root.run(config)

    if not defined(release):
      stderr.writeLine(root)

    root.toSearchResult
