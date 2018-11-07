import std / [random, times]
import Shared / MCTSNode
import .. / .. / Engine / [Action, Config, Search, State]

func playerAlgorithmMCTSP * (config: Config): proc (state: State): SearchResult =
  proc evaluate (node: MCTSNode): void =
    var score = config.evaluateState(node.state)

    for _ in 1 .. 8:
      var state = node.state.swap
      var legals = state.computeActions
      var actions: seq[Action]

      while legals.len > 0:
        let action = legals.rand
        actions.add(action)
        state.applyAction(action)
        legals = state.computeActions
        score = score.min(config.evaluateState(state.swap))

    node.propagate(score)

  proc run (node: MCTSNode): void =
    let wasExpanding = not node.opened
    if wasExpanding:
      node.nodes = @[]
      node.opened = true

      for action in node.state.computeActions:
        if action.actionType != pass and node.move != nil:
          let valid = case node.move.actionType:
            of attack: action.actionType == attack
            of use:    action.actionType == attack or action.actionType == use
            of summon: true
            else:      false

          if not valid:
            continue

        var state = node.state.copy
        state.applyAction(action)
        node.nodes.add(MCTSNode(move: action, parent: node, state: state))

    if node.nodes.len == 0:
      node.evaluate
    elif wasExpanding:
      node.pick.evaluate
    else:
      node.pick.run

  return proc (state: State): SearchResult =
    var root = MCTSNode(state: state)
    let time = cpuTime()

    while cpuTime() - time < config.time:
      for _ in 1 .. 8:
        root.run

    if not defined(release):
      stderr.writeLine(root)

    root.toSearchResult
