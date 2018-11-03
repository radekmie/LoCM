import .. / .. / Engine / [Config, Search, State]

func playerAlgorithmNoop * (config: Config): func (state: State): SearchResult =
  return func (state: State): SearchResult =
    SearchResult()
