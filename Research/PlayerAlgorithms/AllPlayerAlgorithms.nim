import std / tables
import DFS, FlatMonteCarlo, Greedy, MonteCarloTreeSearch, Noop

const playerAlgorithms * = toTable({
  "default":              playerAlgorithmDFS,
  "DFS":                  playerAlgorithmDFS,
  "FlatMonteCarlo":       playerAlgorithmFlatMonteCarlo,
  "MonteCarloTreeSearch": playerAlgorithmMonteCarloTreeSearch,
  "Greedy":               playerAlgorithmGreedy,
  "Noop":                 playerAlgorithmNoop,
})
