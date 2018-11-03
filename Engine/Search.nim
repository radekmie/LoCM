import std / [random, strformat, strutils, times]
import Action, State

type
  SearchResult * = ref object
    actions *: seq[Action]
    score   *: float

func `$` * (searchResult: SearchResult): string =
  result = if searchResult.actions.len == 0: "PASS" else: searchResult.actions.join(";")
  result = &"{result} # score: {searchResult.score}"
