import std / tables
import ClosetAI, Icebox, Manual, Random

const draftEvaluations * = toTable({
  "default":  evaluateDraftManual,
  "ClosetAI": evaluateDraftClosetAI,
  "Icebox":   evaluateDraftIcebox,
  "Manual":   evaluateDraftManual,
  "Random":   evaluateDraftRandom,
})
