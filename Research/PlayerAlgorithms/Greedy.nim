import .. / .. / Engine / [Action, Config, Search, State]

func playerAlgorithmGreedy * (config: Config): proc (state: State): SearchResult =
  return proc (root: State): SearchResult =
    var state = root.copy
    var legals = state.computeActions
    var actions: seq[Action]

    while legals.len > 0:
      var bestIndex = legals.low
      var bestScore = 0.0
      for index in legals.low .. legals.high:
        var after = state.copy
        after.applyAction(legals[index])

        let score = config.evaluateState(after)
        if index == 0 or bestScore < score:
          bestIndex = index
          bestScore = score

      actions.add(legals[bestIndex])
      state.applyAction(legals[bestIndex])
      legals = state.computeActions

    SearchResult(actions: actions, score: config.evaluateState(state))
