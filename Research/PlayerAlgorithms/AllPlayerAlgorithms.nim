import std / tables
import DFS, FlatMonteCarlo, Greedy, Noop

const playerAlgorithms * = toTable({
  "default":        playerAlgorithmDFS,
  "DFS":            playerAlgorithmDFS,
  "FlatMonteCarlo": playerAlgorithmFlatMonteCarlo,
  "Greedy":         playerAlgorithmGreedy,
  "Noop":           playerAlgorithmNoop,
})
