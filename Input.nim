import streams
import strutils

proc getLine * (input: Stream): string {.inline.} =
  input.readLine

proc getStr * (input: Stream): string =
  var data: string
  while true:
    let peek = input.readChar
    if peek == ' ' or peek == '\n' or peek == '\0':
      if data == "":
        continue
      break
    data.add(peek)
  data

proc getInt * (input: Stream): int {.inline.} =
  input.getStr.parseInt
