{.experimental: "parallel".}

import std / [algorithm, random, sequtils, strformat, strutils, threadpool]
import Engine / [Card, Cards, Config, Draft, State]
import Research / [IOHelpers, Referee]

const
  bestsGames = 25
  bestsSize = 5
  bestsWin = 100.0 / 2 / bestsGames
  generations = 1000
  mergeEval = 0.1
  mutationProbability = 0.05
  populationSize = 100
  randoms = 5
  scoreGames = 25
  scoreRounds = 2
  scoreWin = 100.0 / 2 / scoreGames / scoreRounds
  tournamentGames = 10
  tournamentSize = 4

type
  Individual = ref object
    eval: float
    gene: array[160, float]
  Parents = array[2, Individual]
  Population = array[populationSize, Individual]

func toSummary (id: int, avg: float, bests: openArray[Individual]): string =
  let scores = bests.mapIt(&"{it.eval:5.2f}").join(" ")
  &"Generation {id + 1:3}: avg={avg:5.2f} top{bests.len}=[{scores}]"

func toConfig (individual: Individual): Config =
  let lookup = func (card: Card): float = individual.gene[card.cardNumber - 1]

  result = newConfig(player = "Random")
  result.evalDraftFn = func (config: Config, state: State): DraftResult =
    state.evaluateDraftWith(lookup)

proc newIndividual (initialize: bool): Individual =
  result = Individual()
  if initialize:
    result.eval = 50.0
    for index in 0 ..< 160:
      result.gene[index] = rand(1.0)

proc newPopulation (initialize: bool = false): Population =
  for index in result.low .. result.high:
    result[index] = newIndividual(initialize)

func cmp (x, y: Individual): int =
  cmp(x.eval, y.eval)

proc play (x, y: Individual, draft: Draft): bool {.inline.} =
  play(x.toConfig, y.toConfig, draft)

proc roulette (population: Population, eval: float): Individual =
  var score = rand(eval)
  for individual in population:
    score -= individual.eval
    if score <= 0.0:
      return individual

  population[population.high]

proc selectParents (population: Population, draft: Draft): Parents =
  var tournamentIds: array[populationSize, int]
  for index in 0 ..< populationSize:
    tournamentIds[index] = index
  tournamentIds.shuffle

  var tournament: array[tournamentSize, Individual]
  for index in 0 ..< tournamentSize:
    tournament[index] = population[tournamentIds[index]]

  for index in 0 ..< populationSize:
    tournamentIds[index] = 0

  parallel:
    for indexA, a in tournament:
      for indexB, b in tournament:
        if indexA == indexB:
          continue

        for _ in 1 .. tournamentGames:
          let winX = spawn play(a, b, draft)
          let winY = spawn play(b, a, draft)
          if winX: tournamentIds[indexA] += 1
          if winY: tournamentIds[indexB] += 1

  var best1: int = if tournamentIds[0] > tournamentIds[1]: 0 else: 1
  var best2: int = 1 - best1
  for index in 2 ..< tournamentSize:
    if tournamentIds[index] > tournamentIds[best1]:
      best2 = best1
      best1 = index
      continue
    if tournamentIds[index] > tournamentIds[best2]:
      best2 = index
      continue

  [tournament[best1], tournament[best2]]

func sumEvals (population: openArray[Individual]): float =
  for individual in population:
    result += individual.eval

proc measure (
  bests: array[generations, array[bestsSize, Individual]],
  drafts: array[generations, Draft],
  players: openArray[Individual]
): void =
  let winScore = bestsWin / players.len.float
  let configs = players.mapIt(it.toConfig)

  for generation, individuals in bests:
    let draft = drafts[generation]
    for index, best in individuals:
      let opponent = best.toConfig

      best.eval = 0.0

      parallel:
        for config in configs:
          for _ in 0 ..< bestsGames:
            let winX = spawn play(config, opponent, draft)
            let winY = spawn play(opponent, config, draft)
            if     winX: best.eval += winScore
            if not winY: best.eval += winScore

    let avg = sumEvals(individuals) / bestsSize
    echo &"# {stamp()} {toSummary(generation, avg, individuals)}"
    echo &"  {generation} {avg}"
  echo &"  e"

proc main (): void =
  let cards = getCards()
  var offspring = newPopulation()
  var population = newPopulation(true)

  var bests:  array[generations, array[bestsSize, Individual]]
  var drafts: array[generations, Draft]

  for generation in 0 ..< generations:
    drafts[generation] = newDraft(cards)

  for generation in 0 ..< generations:
    let draft = drafts[generation]
    for index in countup(0, populationSize - 2, 2):
      let parents = selectParents(population, draft)

      # CrossoverChildren()
      var child1 = offspring[index + 0]
      var child2 = offspring[index + 1]

      child1.eval = 0.0
      child2.eval = 0.0

      for gene in 0 ..< 160:
        let pickA = rand(1)
        let pickB = 1 - pickA
        child1.gene[gene] = parents[pickA].gene[gene]
        child2.gene[gene] = parents[pickB].gene[gene]

      # MutateChildren()
      for gene in 0 ..< 160:
        if mutationProbability > rand(1.0): child1.gene[gene] = rand(1.0)
        if mutationProbability > rand(1.0): child2.gene[gene] = rand(1.0)

    # ScoreChildrenPopulation()
    for round in 1 .. scoreRounds:
      offspring.sort(cmp, Descending)

      parallel:
        for index in countup(0, populationSize - 2, 2):
          let a = offspring[index + 0]
          let b = offspring[index + 1]
          for game in 1 .. scoreGames:
            let winX = spawn play(a, b, draft)
            let winY = spawn play(b, a, draft)
            if winX: a.eval += scoreWin else: b.eval += scoreWin
            if winY: b.eval += scoreWin else: a.eval += scoreWin

    # PopulationSelectMerge()
    var populationEval = sumEvals(population)
    var offspringEval = sumEvals(offspring)

    var nextPopulation = newPopulation()
    for individual in nextPopulation:
      let x = roulette(population, populationEval)
      let y = roulette(offspring, offspringEval)

      individual.eval = x.eval * (1 - mergeEval) + y.eval * mergeEval
      individual.gene = x.gene

      for pick in draft:
        for card in pick:
          individual.gene[card.cardNumber - 1] = y.gene[card.cardNumber - 1]

    population = nextPopulation
    population.sort(cmp, Descending)

    for index in 0 ..< bestsSize:
      bests[generation][index] = population[index]

    let avg = sumEvals(population) / populationSize
    echo &"# {stamp()} {toSummary(generation, avg, bests[generation])}"

  # Check()
  echo &"# {stamp()} Champion check"
  echo &"set output 'plot.gif'"
  echo &"set terminal gif"
  echo &"set xr [0:{generations}]"
  echo &"set yr [0:100]"
  echo &"set xlabel 'Generation'"
  echo &"set ylabel '% of wins'"

  echo &"plot \\"
  echo &"  '-' using 1:2 title 'Champion' with linespoints, \\"
  echo &"  '-' using 1:2 title 'Random {randoms}' with linespoints"
  measure(bests, drafts, [population[0]])
  measure(bests, drafts, newSeqWith[Individual](randoms, newIndividual(true)))

when isMainModule:
  main()
