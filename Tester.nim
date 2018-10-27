import std / [
  osproc,
  parseopt,
  re,
  sequtils,
  streams,
  strformat,
  strutils,
  times,
]
import Engine / Input

func `$` (dateTime: DateTime): string =
  dateTime.format("yyyy-MM-dd' 'HH:mm:ss'.'fff")

when isMainModule:
  proc main(): void =
    var referee: string
    var player1: string
    var player2: string

    var replays = false
    var threads = countProcessors()
    var games = 0
    var sofar = 0
    var wins1 = 0
    var wins2 = 0

    for kind, key, value in getOpt():
      case kind:
        of cmdLongOption, cmdShortOption:
          case key:
            of "games":   games   = value.parseInt
            of "player1": player1 = value
            of "player2": player2 = value
            of "referee": referee = value
            of "replays": replays = value.parseBool
            of "threads": threads = value.parseInt
            else: discard
        else: discard

    echo &"{now()} Referee: {referee}"
    echo &"{now()} Player1: {player1}"
    echo &"{now()} Player2: {player2}"
    echo &"{now()} Games:   {games}"
    echo &"{now()} Replays: {replays}"
    echo &"{now()} Threads: {threads}"

    var commands = newSeq[string](games)
    for index in commands.low .. commands.high:
      commands[index] = &"""{referee} -p1 "{player1} --seed={index}" -p2 "{player2} --seed={index}" -d "draftChoicesSeed={index:03} seed={index:03} shufflePlayer0Seed={index:03} shufflePlayer1Seed={index:03}""""

    discard execProcesses(
      cmds = commands,
      n = threads,
      options = {poStdErrToStdOut},
      afterRunEvent = proc (id: int; process: Process) =
        var output = process.outputStream
        var input = output.newInput
        let score1 = input.getInt
        let score2 = input.getInt
        let error = score1 < 0 or score2 < 0

        sofar += 1
        wins1 += score1.max(0)
        wins2 += score2.max(0)

        if score1 < 0 or score2 < 0:
          echo &"{now()} End of game {sofar:>3}: ERRORED {score1} {score2}"
        else:
          let total = wins1 + wins2
          let index = total - 1
          let proc1 = 100 * wins1 / total
          let proc2 = 100 * wins2 / total
          echo &"{now()} End of game {sofar:>3}: {proc1:6.2f}% {proc2:6.2f}%"

        if error or replays:
          echo &"{now()} Replay game {sofar:>3}: {commands[sofar - 1]} -s"
    )

  main()
