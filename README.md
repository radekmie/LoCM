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
./Player [algorithm] [evaluator] [timeLimitMs]
./Tester --referee="" --player1="" --player2="" --games=N --threads=N --replays=false
```

### Run

```sh
nim c -d:release Player.nim
nim c -d:release Tester.nim
./Tester \
  --referee="java -jar LoCM.jar" \
  --player1="./Player dfs icebox 100" \
  --player2="./Player flatMonteCarlo closetAI 150" \
  --games=16 \
  --threads=4
```
