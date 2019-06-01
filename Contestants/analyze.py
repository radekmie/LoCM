from re import fullmatch

pattern = r"^(\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d) '(.*?)' '(.*?)' {.*} (-?\d) (-?\d) seed=(\d+) shufflePlayer0Seed=(\d+) draftChoicesSeed=(\d+) shufflePlayer1Seed=(\d+)\s*$"
scoring = {'-1': 'errs', '0': 'lost', '1': 'wins'}

def analyze(file):
  stats = {}

  for chunk in chunks(enumerate(file), 8 * 8):
    for index, line in chunk:
      match = fullmatch(pattern, line)
      if match is None:
        print(f'Invalid format at line {index}')
        continue

      (date, player1, player2, score1, score2, seed0, seed1, draft, seed2) = match.groups()

      if seed0 != seed1 or seed0 != seed2:
        print(f'Invalid params at line {index}')
        continue

      pairA = (player1, player2)
      pairB = (player2, player1)

      if pairA not in stats: stats[pairA] = stats_empty()
      if pairB not in stats: stats[pairB] = stats_empty()

      if score1 == '-1' and score2 == '0': score2 = '1'
      if score2 == '-1' and score1 == '0': score1 = '1'

      stats[pairA][scoring[score1]] += 1
      stats[pairB][scoring[score2]] += 1

  return stats

def analyze_paths(paths):
  combined = {}

  for path in paths:
    with open(path, 'r') as file:
      for players, results in analyze(file).items():
        combined[players] = stats_combine(combined.get(players), results)

  return combined

def chunks(xs, n):
  ys = []
  for x in xs:
    ys.append(x)
    if len(ys) == n:
      yield ys
      ys = []

def stats_combine(statsA, statsB):
  if statsA is None:
    statsA = {'errs': 0, 'lost': 0, 'wins': 0}

  if statsB is not None:
    statsA['errs'] += statsB['errs']
    statsA['lost'] += statsB['lost']
    statsA['wins'] += statsB['wins']

  return statsA

def stats_empty():
  return stats_combine(None, None)

def stats_print(title, stats):
  alls = stats['errs'] + stats['lost'] + stats['wins']
  errs = stats['errs'] / alls * 100
  wins = stats['wins'] / alls * 100

  print(f'{title} wins={wins:5.2f}% errs={errs:5.2f}% alls={alls // 2}')

def main(paths):
  players = {}

  for (player1, player2), results in sorted(analyze_paths(paths).items()):
    if player1 != player2:
      players[player1] = stats_combine(players.get(player1), results)
      stats_print(f'{player1:>30} {player2:>30}', results)

  for player1, results in sorted(players.items()):
    stats_print(f'{player1:>30}', results)

if __name__ == '__main__':
  main(['out-1.txt'])
