import std / [math, random, sequtils, strformat]
import .. / .. / .. / Engine / [Action, Config, Search, State]

type
  MCTSNode * = ref object
    # Info.
    move   *: Action
    nodes  *: seq[MCTSNode]
    opened *: bool
    parent *: MCTSNode
    state  *: State

    # Stats.
    point *: float
    visit *: float

func propagate * (node: MCTSNode, score: float): void =
  node.point += score
  node.visit += 1

  if node.parent != nil:
    node.parent.propagate(score)

func score * (node: MCTSNode): float {.inline.} =
  node.point / node.visit + 0.1 * sqrt(ln(node.parent.visit) / node.visit)

proc pick * (node: MCTSNode): MCTSNode =
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

proc run * (node: MCTSNode, evaluate: proc (node: MCTSNode): void): void =
  let wasExpanding = not node.opened
  if wasExpanding:
    node.nodes = @[]
    node.opened = true

    for action in node.state.computeActions:
      var state = node.state.copy
      state.applyAction(action)
      node.nodes.add(MCTSNode(move: action, parent: node, state: state))

  if node.nodes.len == 0:
    node.evaluate
  elif wasExpanding:
    node.pick.evaluate
  else:
    node.pick.run(evaluate)

func toDot * (node: MCTSNode, counter: var int, scope: float, root: int): string =
  var id = counter
  if id == 0:
    result &= "digraph MCTS {\n"
    result &= "  layout=twopi;\n"
    result &= "  overlap=false;\n"
    result &= "  ranksep=10;\n"
    result &= "  node [style=\"filled\"];\n"

  let move = if node.move == nil: "nil" else: $node.move
  let score = if node.parent == nil: "?" else: $node.score
  let force = if node.parent == nil: scope else: scope * 0.9 * node.visit / max(node.parent.nodes.mapIt(it.visit))
  let label = &"move:{move}\\nscore:{score}\\nvisit:{node.visit}"
  result &= &"  node{id} [fillcolor=\"0.66 {force} 1\" label=\"{label}\"];\n"

  for node in node.nodes:
    counter += 1
    result &= node.toDot(counter, force, id)

  if id != root:
    result &= &"  node{root} -> node{id};\n"

  if id == 0:
    result &= "}\n"

func toDot * (node: MCTSNode): string =
  var counter = 0
  node.toDot(counter, 1, 0)

proc toDotFile * (node: MCTSNode, path: string): void =
  let file = open(path, fmWrite)
  file.write(node.toDot())
  file.close()

proc toSearchResult * (node: MCTSNode): SearchResult =
  var actions: seq[Action]
  var root = node
  while true:
    if root.move != nil:
      actions.add(root.move)
    let next = root.pick
    if next == nil:
      break
    root = next
  SearchResult(actions: actions, score: root.score)

func `$` * (node: MCTSNode): string =
  let move = if node.move == nil: "nil" else: $node.move
  let score = if node.parent == nil: "?" else: $node.score
  &"MCTSNode(move:{move},score:{score},visit:{node.visit},nodes:{node.nodes})"
