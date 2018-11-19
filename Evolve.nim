{.experimental: "parallel".}

import std / [algorithm, random, sequtils, strformat, strutils, threadpool]
import Engine / [Card, Cards, Config, Draft, State]
import Research / [IOHelpers, Referee]

const
  bestsGames = 25
  bestsSize = 5
  generations = 25
  mergeEval = 0.1
  mutationProbability = 0.05
  populationSize = 10
  scoreGames = 25
  scoreRounds = 2
  tournamentGames = 10
  tournamentSize = 4

type
  Individual = ref object
    eval: float
    gene: array[160, float]
  Parents = array[2, Individual]
  Population = array[populationSize, Individual]

func toConfig (individual: Individual): Config =
  let lookup = func (card: Card): float = individual.gene[card.cardNumber - 1]

  result = newConfig(player = "Greedy")
  result.evalDraftFn = func (config: Config, state: State): DraftResult =
    state.evaluateDraftWith(lookup)

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

func sumEvals (population: Population): float =
  for individual in population:
    result += individual.eval

proc main (): void =
  var offspring = newPopulation()
  var population = newPopulation(true)

  var bests:  array[generations, array[bestsSize, Individual]]
  var drafts: array[generations, Draft]

  for generation in 0 ..< generations:
    drafts[generation] = newDraft()
    let draft = drafts[generation]
    for index in countup(0, populationSize div 2, 2):
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
        for index in countup(0, populationSize div 2, 2):
          let a = offspring[index + 0]
          let b = offspring[index + 1]
          for game in 1 .. scoreGames:
            let winX = spawn play(a, b, draft)
            let winY = spawn play(b, a, draft)
            a.eval += (if winX: 1.0 else: 0.0) + (if winY: 0.0 else: 1.0)
            b.eval += (if winY: 1.0 else: 0.0) + (if winX: 0.0 else: 1.0)

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

    echo &"Generation {generation + 1:3}:"
    echo &"  Avg eval: {sumEvals(population) / populationSize:.2f}"
    echo &"  Top eval: " & bests[generation].mapIt(&"{it.eval:.2f}").join(" ")

  # Check()
  echo &""
  echo &"Check"
  let champion = population[0].toConfig

  for generation, individuals in bests:
    let draft = drafts[generation]
    for index, best in individuals:
      let opponent = best.toConfig

      best.eval = 0.0

      parallel:
        for _ in 0 ..< bestsGames:
          let winX = spawn play(champion, opponent, draft)
          let winY = spawn play(opponent, champion, draft)
          best.eval += (if winX: 1.0 else: 0.0) + (if winY: 0.0 else: 1.0)

    let games = bestsGames * 2.0
    let scores = individuals.mapIt(&"{it.eval / games * 100:.2f}%").join(" ")
    echo &"Generation {generation + 1:3}: {scores}"

when isMainModule:
  main()
