AGENTS[0]="python3 AntiSquid/main.py"
AGENTS[1]="./Coac/main"
AGENTS[2]="js ./Conrisc/main.js"
AGENTS[3]="./Marasbot/main"
AGENTS[4]="python3 UJIAgent1/main.py"
AGENTS[5]="python3 UJIAgent2/main.py"

EPOCHS=100
REPLAY=10

for i in {1 .. "$EPOCHS"}; do
  SEED1=$RANDOM # Same for a whole epoch.
  for j in {1 .. "$REPLAY"}; do
    for playerA in "${AGENTS[@]}"; do
      for playerB in "${AGENTS[@]}"; do
        SEED2=$RANDOM # Same for both players.
        echo -n "$(date +%FT%T) '$playerA' '$playerB' "
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
done
