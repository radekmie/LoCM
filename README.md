### Build

```sh
# Debug build
nim c Player.nim
nim c Tester.nim

# Release build
nim c -d:release Player.nim
nim c -d:release Tester.nim
```

### CLI

```sh
./Player --draft="" --player="" --seed=N --state="" --time=N
./Tester --referee="" --plain=false --player1="" --player2="" --games=N --threads=N --replays=false
```

### Run

```sh
nim c -d:release Player.nim
nim c -d:release Tester.nim
./Tester \
  --referee="java -jar LoCM.jar" \
  --player1="./Player --draft=Icebox --player=DFS --time=100" \
  --player2="./Player --draft=ClosetAI --player=FMC --time=150" \
  --games=16 \
  --threads=4
```

### Roadmap

**[Draft evaluations](Research/DraftEvaluations):**

* [x] ClosetAI (`--draft=ClosetAI`, [source](Research/DraftEvaluations/ClosetAI.nim))
* [x] Icebox (`--draft=Icebox`, [source](Research/DraftEvaluations/Icebox.nim))
* [x] Manual (`--draft=Manual`, [source](Research/DraftEvaluations/Manual.nim))
* [x] Random (`--draft=Random`, [source](Research/DraftEvaluations/Random.nim))

**[Player algorithms](Research/PlayerAlgorithms):**

* [ ] Bridge Burning Monte Carlo Tree Search
* [x] DFS (`--player=DFS`, [source](Research/PlayerAlgorithms/DFS.nim))
* [x] Flat Monte Carlo (`--player=FMC`, [source](Research/PlayerAlgorithms/FMC.nim))
* [x] Greedy (`--player=Greedy`, [source](Research/PlayerAlgorithms/Greedy.nim))
* [x] Monte Carlo Tree Search (`--player=MCTS`, [source](Research/PlayerAlgorithms/MCTS.nim))
* [x] Monte Carlo Tree Search - lookahead (`--player=MCTS0`, [source](Research/PlayerAlgorithms/MCTS0.nim))
* [ ] Monte Carlo Tree Search + pruning
* [x] Noop (`--player=Noop`, [source](Research/PlayerAlgorithms/Noop.nim))

**[State evaluations](Research/StateEvaluations):**

* [x] Simple (`--state=Simple`, [source](Research/StateEvaluations/Simple.nim))
