from json import loads
from numpy import average, std
from re import fullmatch, match

pattern = r"^(\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d) '(.*?)' '(.*?)' ({.*}) (-?\d) (-?\d) seed=(\d+) shufflePlayer0Seed=(\d+) draftChoicesSeed=(\d+) shufflePlayer1Seed=(\d+)\s*$"
scoring = {'-1': 'errs', '0': 'lost', '1': 'wins'}

def analyze(file):
  stats = {}
  times = {}

  for chunk in chunks(enumerate(file), 8 * 8):
    for index, line in chunk:
      found = fullmatch(pattern, line)
      if found is None:
        print(f'Invalid format at line {index}')
        continue

      date, player1, player2, json, score1, score2, seed0, seed1, draft, seed2 = found.groups()

      if seed0 != seed1 or seed0 != seed2:
        print(f'Invalid params at line {index}')
        continue

      pairA = (player1, player2)
      pairB = (player2, player1)

      if pairA not in stats: stats[pairA] = stats_empty()
      if pairB not in stats: stats[pairB] = stats_empty()

      if score1 != '-1' and score2 != '-1':
        json = loads(json)
        for message in json['summaries']:
          if message == None:
            continue

          found = match(r'\$(\d) (\d+)ns at turn (\d+)', message)
          if found is None:
            continue

          player, time, turn = found.groups()
          time = int(time) / 1_000_000

          # Time limit is 200, but CG servers are quite fast.
          # 10% budget should be enough.
          if time > 200 * 1.1:
            if player == '0': score1 = '-1'
            if player == '1': score2 = '-1'
            break

          if player1 not in times: times[player1] = []
          if player2 not in times: times[player2] = []
          if player == '0': times[player1].append(time)
          if player == '1': times[player2].append(time)

      if score1 == '-1' and score2 == '0': score2 = '1'
      if score2 == '-1' and score1 == '0': score1 = '1'

      stats[pairA][scoring[score1]] += 1
      stats[pairB][scoring[score2]] += 1

  return stats, times

def analyze_paths(paths):
  stats_combined = {}
  times_combined = {}

  for path in paths:
    with open(path, 'r') as file:
      stats, times = analyze(file)
      for players, results in stats.items():
        stats_combined[players] = stats_combine(stats_combined.get(players), results)
      for player, time in times.items():
        if player not in times_combined:
          times_combined[player] = []
        times_combined[player] += time

  return stats_combined, times_combined

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

def stats_print(title, stats, extra = ''):
  alls = stats['errs'] + stats['lost'] + stats['wins']
  errs = stats['errs'] / alls * 100
  wins = stats['wins'] / alls * 100

  print(f'{title} wins={wins:5.2f}% errs={errs:5.2f}% alls={alls // 2}{extra}')

def main(paths):
  players = {}

  stats, times = analyze_paths(paths)

  for (player1, player2), results in sorted(stats.items()):
    if player1 != player2:
      players[player1] = stats_combine(players.get(player1), results)
      stats_print(f'{player1:>30} {player2:>30}', results)

  for player1, results in sorted(players.items(), key=lambda x: -x[1]['wins']):
    stats_print(f'{player1:>30}', results, f' avg={average(times[player1]):6.2f}±{std(times[player1]):5.2f}ms')

if __name__ == '__main__':
  main(['out-1.txt', 'out-2.txt', 'out-3.txt', 'out-4.txt'])
