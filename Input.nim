import streams
import strutils

proc getLine * (input: Stream): string {.inline.} =
  input.readLine

proc getStr * (input: Stream): string =
  var data: string
  while true:
    if input of StringStream:
      let peek = input.peekChar
      if peek == ' ' or peek == '\n' or peek == '\0':
        if peek != '\0':
          discard input.readChar
        break
      data.add(input.readChar)
    else:
      let peek = input.readChar
      if peek == ' ' or peek == '\n':
        if data == "":
          continue
        break
      data.add(peek)
  data

proc getInt * (input: Stream): int {.inline.} =
  input.getStr.parseInt
