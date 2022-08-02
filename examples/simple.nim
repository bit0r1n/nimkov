import options, std/os, strutils
import nimkov/[generator, objects, validators]

var file = open("texts.txt")
let phrases = file.readAll().split("\n")
file.close()


let markov = newMarkov(phrases)

# simple generating
echo markov.generate(newMarkovGenerateOptions(begin = some "игорь, ты", attempts = 500)).get & "\n"