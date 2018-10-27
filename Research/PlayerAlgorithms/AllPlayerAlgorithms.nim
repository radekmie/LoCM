import std / tables
import DFS, FlatMonteCarlo, Noop

const playerAlgorithms * = toTable({
  "default":        playerAlgorithmDFS,
  "DFS":            playerAlgorithmDFS,
  "FlatMonteCarlo": playerAlgorithmFlatMonteCarlo,
  "Noop":           playerAlgorithmNoop,
})
