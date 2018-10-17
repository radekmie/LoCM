import osproc
import parseopt
import re
import sequtils
import streams
import strformat
import strutils
import times

import Input

func `$` (dateTime: DateTime): string =
  dateTime.format("yyyy-MM-dd' 'HH:mm:ss'.'fff")

func `$` (duration: Duration): string =
  fmt"{duration.seconds}.{duration.milliseconds:03}s"

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

    fmt"{now()} Referee: {referee}".echo
    fmt"{now()} Player1: {player1}".echo
    fmt"{now()} Player2: {player2}".echo
    fmt"{now()} Games:   {games}".echo
    fmt"{now()} Replays: {replays}".echo
    fmt"{now()} Threads: {threads}".echo

    let command = fmt"{referee} -p1 '{player1}' -p2 '{player2}'"
    var befores = newSeqOfCap[DateTime](games)

    discard execProcesses(
      cmds = repeat[string](command, games),
      n = threads,
      options = {poStdErrToStdOut},
      beforeRunEvent = proc (id: int) =
        befores[id] = now(),
      afterRunEvent = proc (id: int; process: Process) =
        var output = process.outputStream
        let score1 = output.getInt
        let score2 = output.getInt
        let error = score1 < 0 or score2 < 0
        let took = now() - befores[id]

        sofar += 1
        wins1 += score1.max(0)
        wins2 += score2.max(0)

        if score1 < 0 or score2 < 0:
          fmt"{now()} End of game {sofar:>3} [{took}]: ERRORED {score1} {score2}".echo
        else:
          let total = wins1 + wins2
          let index = total - 1
          let proc1 = 100 * wins1 / total
          let proc2 = 100 * wins2 / total

          fmt"{now()} End of game {sofar:>3} [{took}]: {proc1:6.2f}% {proc2:6.2f}%".echo

        if error or replays:
          let options = output.readAll.strip.replace(re"\n", " ")
          fmt"{now()} Replay game {sofar:>3} [{took}]: {command} -d '{options}' -s".echo
    )

  main()
