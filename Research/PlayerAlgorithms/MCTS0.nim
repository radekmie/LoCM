import std / [random, times]
import Shared / MCTSNode
import .. / .. / Engine / [Action, Config, Search, State]

func playerAlgorithmMCTS0 * (config: Config): proc (state: State): SearchResult =
  proc evaluate (node: MCTSNode): void =
    node.propagate(config.evaluateState(node.state))

  return proc (state: State): SearchResult =
    var root = MCTSNode(state: state)
    let time = cpuTime()

    while cpuTime() - time < config.time:
      for _ in 1 .. 8:
        root.run(evaluate)

    if not defined(release):
      stderr.writeLine(root)

    root.toSearchResult
