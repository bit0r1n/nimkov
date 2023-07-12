import strutils
import ../nimkov/[generator, objects, typedefs, validators]

var file = open("texts.txt")
let phrases = file.readAll().split("\n")
file.close()

let markov = newMarkov(phrases, kind = mgtWeighted)

try:
  echo markov.generate(
    newMarkovGenerateOptions(
      validator = symbolsCount(50, 200),
      attempts = 5000
    )
  )
except CatchableError as e:
  echo e.name