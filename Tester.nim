import osproc
import parseopt
import streams
import strformat
import strutils
import times

import Input

when isMainModule:
  proc main(): void =
    var referee: string
    var player1: string
    var player2: string

    var threads = countProcessors()
    var games = 0
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
            of "threads": threads = value.parseInt
            else: discard
        else: discard

    fmt"{now()} Referee: {referee}".echo
    fmt"{now()} Player1: {player1}".echo
    fmt"{now()} Player2: {player2}".echo
    fmt"{now()} Games:   {games}".echo
    fmt"{now()} Threads: {threads}".echo

    var cmds = newSeq[string](games)
    var outs = newSeq[string](games)

    for index in cmds.low .. cmds.high:
      cmds[index] = fmt"{referee} -p1 '{player1}' -p2 '{player2}'"

    discard execProcesses(
      cmds = cmds,
      n = threads,
      options = {poStdErrToStdOut},
      afterRunEvent = proc (id: int; process: Process) =
        var output = process.outputStream
        var score1 = output.getInt
        var score2 = output.getInt

        wins1 += score1.max(0)
        wins2 += score2.max(0)

        let total = wins1 + wins2
        let index = total - 1
        let proc1 = 100 * wins1 / total
        let proc2 = 100 * wins2 / total

        outs[index] = output.readAll.strip

        fmt"{now()} End of game {total:>3}: {proc1:6.2f}% {proc2:6.2f}%".echo
    )

  main()
