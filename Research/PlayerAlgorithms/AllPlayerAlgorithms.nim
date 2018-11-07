import std / tables
import DFS, FMC, Greedy, MCTS, MCTS0, MCTSP, Noop

const playerAlgorithms * = toTable({
  "default": playerAlgorithmDFS,
  "DFS":     playerAlgorithmDFS,
  "FMC":     playerAlgorithmFMC,
  "Greedy":  playerAlgorithmGreedy,
  "MCTS":    playerAlgorithmMCTS,
  "MCTS0":   playerAlgorithmMCTS0,
  "MCTSP":   playerAlgorithmMCTSP,
  "Noop":    playerAlgorithmNoop,
})
