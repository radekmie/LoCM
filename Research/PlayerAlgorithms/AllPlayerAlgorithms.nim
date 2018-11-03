import std / tables
import DFS, FMC, Greedy, MCTS, Noop

const playerAlgorithms * = toTable({
  "default": playerAlgorithmDFS,
  "DFS":     playerAlgorithmDFS,
  "FMC":     playerAlgorithmFMC,
  "Greedy":  playerAlgorithmGreedy,
  "MCTS":    playerAlgorithmMCTS,
  "Noop":    playerAlgorithmNoop,
})
