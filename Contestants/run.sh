AntiSquid="python3 AntiSquid/main.py"
Coac="./Coac/main"
Conrisc="js ./Conrisc/main.js"
Marasbot="./Marasbot/main"
UJIAgent1="python3 UJIAgent1/main.py"
UJIAgent2="python3 UJIAgent2/main.py"

Agents=("$AntiSquid" "$Coac" "$Conrisc" "$Marasbot" "$UJIAgent1" "$UJIAgent2")
for n in {1..100}; do
  SEED1=$RANDOM # For all games in a given set.
  for playerA in "${Agents[@]}"; do
    for playerB in "${Agents[@]}"; do
      SEED2=$RANDOM # For each single game.
      echo -n "$playerA $playerB "
      java -jar ../LoCM.jar \
        -p1 "$playerA" \
        -p2 "$playerB" \
        -l /dev/stdout \
        -d "draftChoicesSeed=$SEED1 seed=$SEED2 shufflePlayer0Seed=$SEED2 shufflePlayer1Seed=$SEED2" \
        | awk 1 ORS=' '
      echo
    done
  done
done
