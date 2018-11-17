{.experimental: "parallel".}

import std / [algorithm, random, sequtils, strformat, threadpool]
import Engine / [Card, Cards, Config, Draft, State]
import Research / IOHelpers
import Runner

const
  generations = 100
  mutationProbability = 0.05
  populationSize = 10
  scoreGames = 25
  scoreRounds = 2
  tournamentGames = 10
  tournamentSize = 4

type
  Individual = ref object
    eval: int
    gene: array[160, float]
  Parents = tuple[best1: Individual, best2: Individual]
  Population = array[populationSize, Individual]
  Offspring = array[populationSize * 2, Individual]

func toConfig (individual: Individual): Config =
  result = newConfig(player = "Greedy")
  result.evalDraftFn = func (config: Config, state: State): DraftResult =
    state.evaluateDraftWith(func (card: Card): float = individual.gene[card.cardNumber - 1])

proc newDraft (): Draft =
  var cards = getCards()
  cards.shuffle

  for pick in 0 ..< 30:
    for card in 0 ..< 3:
      result[pick][card] = cards[pick * 3 + card]

proc newIndividual (): Individual =
  result = Individual()
  for index in 0 ..< 160:
    result.gene[index] = rand(1.0)

proc newOffspring (): Offspring =
  for index in result.low .. result.high:
    result[index] = Individual()

proc newPopulation (): Population =
  for index in result.low .. result.high:
    result[index] = newIndividual()

proc play (x, y: Individual, draft: Draft): bool =
  play(x.toConfig, y.toConfig, draft)

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

  (best1: tournament[best1], best2: tournament[best2])

proc main (): void =
  var offspring = newOffspring()
  var population = newPopulation()

  for _ in 1 .. generations:
    let draft = newDraft()
    for index in 0 ..< populationSize:
      let (best1, best2) = selectParents(population, draft)

      # CrossoverChildren()
      var child1 = offspring[index * 2 + 0]
      var child2 = offspring[index * 2 + 1]

      child1.eval = 0
      child2.eval = 0

      for index in 0 ..< 160:
        let pick = rand(1)
        child1.gene[index] = (if pick == 0: best1 else: best2).gene[index]
        child2.gene[index] = (if pick == 0: best2 else: best1).gene[index]

      # MutateChildren()
      for index in 0 ..< 160:
        if mutationProbability > rand(1.0):
          child1.gene[index] = rand(1.0)
        if mutationProbability > rand(1.0):
          child2.gene[index] = rand(1.0)

    # ScoreChildrenPopulation()
    for _ in 0 ..< scoreRounds:
      offspring.sort(func (x, y: Individual): int = cmp(x.eval, y.eval), Descending)

      parallel:
        for index in countup(0, populationSize, 2):
          let a = offspring[index + 0]
          let b = offspring[index + 1]
          for _ in 0 ..< scoreGames:
            let winX = spawn play(a, b, draft)
            let winY = spawn play(b, a, draft)
            a.eval += (if winX: 1 else: 0) + (if winY: 0 else: 1)
            b.eval += (if winY: 1 else: 0) + (if winX: 0 else: 1)

    # PopulationSelectMerge()
    for index in 0 ..< populationSize:
      var x = population[index]
      let y = offspring.rand

      x.eval = (x.eval + y.eval) div 2

      for pick in draft:
        for card in pick:
          x.gene[card.cardNumber - 1] = y.gene[card.cardNumber - 1]

    population.sort(func (x, y: Individual): int = cmp(x.eval, y.eval), Descending)
    echo population.mapIt(it.eval)

when isMainModule:
  main()
