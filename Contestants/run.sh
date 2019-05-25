AntiSquid="python3 AntiSquid/main.py"
Coac="./Coac/main"
Conrisc="js ./Conrisc/main.js"
Marasbot="./Marasbot/main"
UJIAgent1="python3 UJIAgent1/main.py"
UJIAgent2="python3 UJIAgent2/main.py"

Agents=("$AntiSquid" "$Coac" "$Conrisc" "$Marasbot" "$UJIAgent1" "$UJIAgent2")
for playerA in "${Agents[@]}"; do
  for playerB in "${Agents[@]}"; do
    echo $playerA $playerB
    java -jar ../LoCM.jar -p1 "$playerA" -p2 "$playerB"
  done
done
