import std / [random, times]
import Shared / MCTSNode
import .. / .. / Engine / [Action, Config, Search, State]

const
  PHASES = 2

proc playerAlgorithmBBMCTS * (config: Config, state: State): SearchResult =
  proc evaluate (node: MCTSNode): void =
    var score = config.evalState(node.state)

    for _ in 1 .. 8:
      var state = node.state.copy.swap
      var legals = state.computeActions
      var actions: seq[Action]

      while legals.len > 0:
        let action = legals.rand
        actions.add(action)
        state.applyAction(action)
        legals = state.computeActions
        score = score.min(config.evalState(state.swap))

    node.propagate(score)

  block:
    var root = MCTSNode(state: state)
    var next = root
    let time = cpuTime()

    for phase in 1 .. PHASES:
      while cpuTime() - time < config.time * phase.float / PHASES.float:
        for _ in 1 .. 8:
          next.run(evaluate)

      let temp = next.pick
      if temp == nil:
        break

      next = temp

    if not defined(release):
      stderr.writeLine(root)

    root.toSearchResult
