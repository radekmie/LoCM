{.experimental: "parallel".}

import std / [algorithm, random, sequtils, strformat, strutils, threadpool]
import Engine / [Card, Cards, Config, Draft, State]
import Research / [IOHelpers, Referee]

const
  # evolveToBests
  bestsSize = 5
  generations = 1000
  mergeEval = 0.1
  mutationProbability = 0.05
  populationSize = 100
  scoreGames = 25
  scoreRounds = 2
  tournamentGames = 10
  tournamentSize = 4

  # plotBaselines
  baselineDrafts = 100
  baselinesGames = 25

  # plotChampions
  bestsGames = 25
  champions = 5
  randoms = 5

  # plotEvolution
  progressDrafts = 100
  progressEnemies = 10
  progressGames = 25

type
  Baseline = tuple[drafts: Drafts, evaluator: string, title: string]
  Individual = ref object
    eval: float
    gene: array[160, float]
  Bests = array[generations, array[bestsSize, Individual]]
  Drafts = seq[Draft]
  Parents = array[2, Individual]
  Population = array[populationSize, Individual]

func toSummary (id: int, avg: float, bests: openArray[Individual]): string =
  let scores = bests.mapIt(&"{it.eval:5.2f}").join(" ")
  &"Generation {id + 1:4}: avg={avg:5.2f} top{bests.len}=[{scores}]"

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

proc evolveToBests (bests: var Bests, drafts: Drafts): void =
  var offspring  = newPopulation()
  var population = newPopulation(true)

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
    let scoreWin = 100.0 / (2 * scoreGames * scoreRounds)
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

proc plotBaselines (bests: Bests, lines: seq[Baseline]): void =
  echo &"set output 'plot-baselines.svg'"
  echo &"set terminal svg font 'monospace:Bold,16' linewidth 2 size 1000,600"
  echo &"set xlabel 'Generation'"
  echo &"set ylabel '% of wins'"

  echo &"# Running average of size n"
  echo &"n = {min(10, generations)}"
  for k in lines.low .. lines.high:
    echo &"do for[i = 1 : n] {{"
    echo &"  eval(sprintf('pre{k}%d = 0', i))"
    echo &"}}"

    echo &"shift{k} = '('"
    echo &"do for[i = n : 2 : -1] {{"
    echo &"  shift{k} = sprintf('%spre{k}%d = pre{k}%d, ', shift{k}, i, i - 1)"
    echo &"}}"
    echo &"shift{k} = shift{k} . 'pre{k}1 = x)'"

    echo &"sum{k} = '(pre{k}1'"
    echo &"do for[i = 2 : n] {{"
    echo &"  sum{k} = sprintf('%s + pre{k}%d', sum{k}, i)"
    echo &"}}"
    echo &"sum{k} = sum{k} . ')'"

    echo &"samples{k}(x) = $0 > (n - 1) ? n : ($0 + 1)"
    echo &"shift{k}(x) = @shift{k}"
    echo &"avg{k}(x) = (shift{k}(x), @sum{k} / samples{k}($0))"

  var scores = newSeq[float](lines.high)

  for k, line in lines:
    echo &"$baseline{k} <<EOD"

    let baseline = newConfig(draft = line.evaluator, player = "Random")

    let score = 100.0 / 2 / baselinesGames / line.drafts.len.float
    for generation, group in bests:
      for index, individual in group:
        let player = individual.toConfig

        individual.eval = 0.0

        parallel:
          for draft in line.drafts:
            for game in 1 .. baselinesGames:
              let winX = spawn play(player, baseline, draft)
              let winY = spawn play(baseline, player, draft)
              if     winX: individual.eval += score
              if not winY: individual.eval += score

      let avg = sumEvals(group) / bestsSize
      scores[k] += avg / generations

      echo &"# {stamp()} {toSummary(generation, avg, group)}"
      echo &"  {generation + 1:4} {avg:5.2f}"
    echo &"EOD"

  echo &"plot \\"
  for k, line in lines:
   let label = &"{line.title} {scores[k]:5.2f}"
   let trail = if k == lines.high: "" else: ", \\"
   echo &"  $baseline{k} using 1:(avg{k}($2)) title '{label}' with lines{trail}"

proc plotChampions (bests: Bests, drafts: Drafts): void =
  echo &"set output 'plot-champions.svg'"
  echo &"set terminal svg font 'monospace:Bold,16' linewidth 2 size 1000,600"
  echo &"set xlabel 'Generation'"
  echo &"set ylabel '% of wins'"

  echo &"# Running average of size n"
  echo &"n = {min(10, generations)}"
  for k in 0 .. champions:
    echo &"do for[i = 1 : n] {{"
    echo &"  eval(sprintf('pre{k}%d = 0', i))"
    echo &"}}"

    echo &"shift{k} = '('"
    echo &"do for[i = n : 2 : -1] {{"
    echo &"  shift{k} = sprintf('%spre{k}%d = pre{k}%d, ', shift{k}, i, i - 1)"
    echo &"}}"
    echo &"shift{k} = shift{k} . 'pre{k}1 = x)'"

    echo &"sum{k} = '(pre{k}1'"
    echo &"do for[i = 2 : n] {{"
    echo &"  sum{k} = sprintf('%s + pre{k}%d', sum{k}, i)"
    echo &"}}"
    echo &"sum{k} = sum{k} . ')'"

    echo &"samples{k}(x) = $0 > (n - 1) ? n : ($0 + 1)"
    echo &"shift{k}(x) = @shift{k}"
    echo &"avg{k}(x) = (shift{k}(x), @sum{k} / samples{k}($0))"

  var labels: array[champions + 1, string]
  var scores: array[champions + 1, float]

  for k in 0 .. champions:
    echo &"$data{k} <<EOD"

    var players: seq[Config]
    if k == 0:
      players = newSeqWith[Config](randoms, newIndividual(true).toConfig)
      labels[k] = &"Randoms {randoms:5}"
    else:
      let generation = k * int(generations / champions) - 1
      players.add(bests[generation][0].toConfig)
      labels[k] = &"Champion {generation + 1:4}"

    let score = 100.0 / 2 / bestsGames / players.len.float
    for generation, group in bests:
      let draft = drafts[generation]
      for index, enemy in group:
        let opponent = enemy.toConfig

        enemy.eval = 0.0

        parallel:
          for player in players:
            for game in 1 .. bestsGames:
              let winX = spawn play(player, opponent, draft)
              let winY = spawn play(opponent, player, draft)
              if     winX: enemy.eval += score
              if not winY: enemy.eval += score

      let avg = sumEvals(group) / bestsSize
      scores[k] += avg / generations

      echo &"# {stamp()} {toSummary(generation, avg, group)}"
      echo &"  {generation + 1:4} {avg:5.2f}"
    echo &"EOD"

  echo &"plot \\"
  for k in 0 .. champions:
   let label = &"{labels[k]} {scores[k]:5.2f}"
   let trail = if k == champions: "" else: ", \\"
   echo &"  $data{k} using 1:(avg{k}($2)) title '{label}' with lines{trail}"

proc plotEvolution (bests: Bests, drafts1: Drafts, drafts2: Drafts): void =
  var players: array[generations * bestsSize, Individual]
  for index in players.low .. players.high:
    players[index] = bests[(index / bestsSize).int][index mod bestsSize]

  var enemies: array[progressEnemies, Config]
  for index in enemies.low .. enemies.high:
    enemies[index] = newIndividual(true).toConfig

  echo &"set output 'plot-evolution.svg'"
  echo &"set terminal svg font 'monospace:Bold,16' linewidth 2 size 1000,600"
  echo &"set xlabel 'Known drafts %'"
  echo &"set ylabel 'Fresh drafts %'"
  echo &"$progress <<EOD"
  for index, player in players:
    let config = player.toConfig
    var coords = [0.0, 0.0]

    for coord, drafts in [drafts1, drafts2]:
      player.eval = 0.0

      let score = 100.0 / 2 / progressGames / (enemies.len * drafts.len).float
      for draft in drafts:
        parallel:
          for enemy in enemies:
            for game in 1 .. progressGames:
              let winX = spawn play(config, enemy, draft)
              let winY = spawn play(enemy, config, draft)
              if     winX: player.eval += score
              if not winY: player.eval += score
      coords[coord] = player.eval

    echo &"# {stamp()} Player {index + 1:4}"
    echo &"  {coords[0]:5.2f} {coords[1]:5.2f}"
  echo &"EOD"
  echo &"a = 1"
  echo &"b = 50"
  echo &"fit(x) = a * x + b"
  echo &"fit fit(x) $progress via a, b"
  echo &"plot \\"
  echo &"  $progress notitle pointsize 0.5 pointtype 7, \\"
  echo &"  fit(x) title sprintf('y = %fx + %f', a, b)"

proc main (): void =
  let cards = getCards()
  let drafts1: Drafts = newSeqWith[Draft](generations, newDraft(cards))
  let drafts2: Drafts = newSeqWith[Draft](progressDrafts, newDraft(cards))
  let drafts3: Drafts = newSeqWith[Draft](baselineDrafts, newDraft(cards))

  var bests: Bests
  evolveToBests(bests, drafts1)
  plotChampions(bests, drafts1)
  plotEvolution(bests, drafts1, drafts2)
  plotBaselines(bests, @[
    (drafts1, "ClosetAI", "vs ClosetAI, known"),
    (drafts3, "ClosetAI", "vs ClosetAI, fresh"),
    (drafts1, "Icebox", "vs Icebox, known"),
    (drafts3, "Icebox", "vs Icebox, fresh"),
  ])

when isMainModule:
  main()
