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
  node.point / node.visit + EXPLORATION * sqrt(ln(node.parent.visit) / node.visit)

proc pick (node: Node): Node =
  # Nothing to pick from.
  if node.nodes.len == 0:
    return nil

  # Not opened first.
  var notOpened: seq[int]
  for index in node.nodes.low .. node.nodes.high:
    if not node.nodes[index].opened:
      notOpened.add(index)
  if notOpened.len > 0:
    return node.nodes[notOpened.rand]

  # Best.
  var bestIndex = 0
  var bestScore = NegInf

  for index in node.nodes.low .. node.nodes.high:
    let score = node.nodes[index].score
    if score > bestScore:
      bestIndex = index
      bestScore = score

  node.nodes[bestIndex]

proc run (node: Node, config: Config): void =
  let wasExpanding = not node.opened
  if wasExpanding:
    node.nodes = @[]
    node.opened = true

    for action in node.state.computeActions:
      var state = node.state.copy
      state.applyAction(action)
      node.nodes.add(Node(move: action, parent: node, state: state))

  if node.nodes.len == 0:
    node.evaluate(config)
  elif wasExpanding:
    node.pick.evaluate(config)
  else:
    node.pick.run(config)

proc toSearchResult (node: Node): SearchResult =
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
  let score = if node.parent == nil: "?" else: $node.score
  result = &"Node(move:{move},score:{score},opened:{node.opened},point:{node.point},visit:{node.visit},nodes:{node.nodes})"

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
