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
  --player2="./Player --draft=ClosetAI --player=FlatMonteCarlo --time=150" \
  --games=16 \
  --threads=4
```

### Roadmap

**[Draft evaluations](Research/DraftEvaluations):**

* [x] ClosetAI ([source](Research/DraftEvaluations/ClosetAI.nim))
* [x] Icebox ([source](Research/DraftEvaluations/Icebox.nim))
* [x] Manual ([source](Research/DraftEvaluations/Manual.nim))
* [x] Random ([source](Research/DraftEvaluations/Random.nim))

**[Player algorithms](Research/PlayerAlgorithms):**

* [ ] Bridge Burning Monte Carlo Tree Search
* [x] DFS ([source](Research/PlayerAlgorithms/DFS.nim))
* [x] Flat Monte Carlo ([source](Research/PlayerAlgorithms/FlatMonteCarlo.nim))
* [x] Greedy ([source](Research/PlayerAlgorithms/Greedy.nim))
* [ ] Monte Carlo Tree Search
* [ ] Monte Carlo Tree Search + opponent lookahead (greedy)
* [ ] Monte Carlo Tree Search + opponent lookahead (greedy) + pruning
* [x] Noop ([source](Research/PlayerAlgorithms/Noop.nim))

**[State evaluations](Research/StateEvaluations):**

* [x] Simple ([source](Research/StateEvaluations/Simple.nim))
