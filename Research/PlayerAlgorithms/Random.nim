import std / [random, strformat]
import .. / .. / Engine / [Config, Search, State]

var branchAll = 0
var branchMax = 0
var branchSum = 0

var depthAll = 0
var depthMax = 0
var depthSum = 0

var sizeAll = 0
var sizeMax = 0
var sizeSum = 0

func treeStats (state: State): (int, int) =
  let actions = state.computeActions

  var depth = 0
  var size  = 1

  for action in actions:
    let (depth2, size2) = state.apply(action).treeStats
    depth = depth.max(depth2 + 1)
    size += size2

  return (depth, size)

proc analyze (state: State): void =
  let branch = state.computeActions.len
  let (depth, size) = state.treeStats

  branchAll = branchAll + 1
  branchMax = branchMax.max(branch)
  branchSum = branchSum + branch

  depthAll = depthAll + 1
  depthMax = depthMax.max(depth)
  depthSum = depthSum + depth

  sizeAll = sizeAll + 1
  sizeMax = sizeMax.max(size)
  sizeSum = sizeSum + size

  echo &"branch={branch} branch.avg={branchSum / branchAll:.2f} branch.max={branchMax} depth={depth} depth.avg={depthSum / depthAll:.2f} depth.max={depthMax} size={size} size.avg={sizeSum / sizeAll:.2f} size.max={sizeMax}"

proc playerAlgorithmRandom * (config: Config, root: State): SearchResult =
  result = SearchResult()

  var state = root.copy
  var legal = state.computeActions

  state.analyze

  while legal.len > 0:
    let action = legal.rand
    result.actions.add(action)
    state.applyAction(action)
    legal = state.computeActions
