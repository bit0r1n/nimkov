import options, strutils
import ../nimkov/[generator, objects]

var file = open("texts.txt")
let phrases = file.readAll().split("\n")
file.close()

let markov = newMarkov(phrases)

try:
  echo markov.generate(newMarkovGenerateOptions(begin = some "игорь, ты", attempts = 1))
except CatchableError as e:
  echo e.name