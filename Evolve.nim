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

proc newIndividual (initialize: bool): Individual =
  result = Individual()
  if initialize:
    for index in 0 ..< 160:
      result.gene[index] = rand(1.0)

proc newPopulation (initialize: bool = false): Population =
  for index in result.low .. result.high:
    result[index] = newIndividual(initialize)

func cmp (x, y: Individual): int =
  cmp(x.eval, y.eval)

proc play (x, y: Individual, draft: Draft): bool =
  play(x.toConfig, y.toConfig, draft)

proc roulette (population: Population, eval: int): Individual =
  var score = rand(eval)
  for individual in population:
    score -= individual.eval
    if score <= 0:
      return individual

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

func sumEvals (population: Population): int =
  for individual in population:
    result += individual.eval

proc main (): void =
  var offspring = newPopulation()
  var population = newPopulation(true)

  for generation in 1 .. generations:
    let draft = newDraft()
    for index in countup(0, populationSize div 2, 2):
      let (best1, best2) = selectParents(population, draft)

      # CrossoverChildren()
      var child1 = offspring[index + 0]
      var child2 = offspring[index + 1]

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
      offspring.sort(cmp, Descending)

      parallel:
        for index in countup(0, populationSize div 2, 2):
          let a = offspring[index + 0]
          let b = offspring[index + 1]
          for _ in 0 ..< scoreGames:
            let winX = spawn play(a, b, draft)
            let winY = spawn play(b, a, draft)
            a.eval += (if winX: 1 else: 0) + (if winY: 0 else: 1)
            b.eval += (if winY: 1 else: 0) + (if winX: 0 else: 1)

    # PopulationSelectMerge()
    var populationEval = sumEvals(population)
    var offspringEval = sumEvals(offspring)

    var nextPopulation = newPopulation()
    for individual in nextPopulation:
      let x = roulette(population, populationEval)
      let y = roulette(offspring, offspringEval)

      individual.eval = (x.eval + y.eval) div 2
      individual.gene = x.gene

      for pick in draft:
        for card in pick:
          individual.gene[card.cardNumber - 1] = y.gene[card.cardNumber - 1]

    population = nextPopulation
    population.sort(cmp, Descending)

    echo &"Generation {generation}"
    echo &"  Avg fitness: {sumEvals(population) / populationSize}"
    echo &"  Top fitness: {population[0 .. 4].mapIt(it.eval)}"

when isMainModule:
  main()
