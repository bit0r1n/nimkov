import std/[tables, strutils, options, random, sequtils]
import ./utils, ./constants, ./objects, ./typedefs

randomize()

# private fields moment
type MarkovGenerator* = ref object
    samples: seq[string]
    model: Table[string, seq[string]]
    wordProc: MarkovProcessWordProc

iterator sampleToFrames(sample: string, wordProc: MarkovProcessWordProc): string =
    yield mrkvStart

    for word in sample.split(" "):
        if word == mrkvStart or word == mrkvEnd: continue
        let newWord = wordProc(word)
        if newWord.isSome:
            yield newWord.get()

    yield mrkvEnd

proc addSample*(generator: MarkovGenerator, sample: string) =
    ## Adds string to samples.
    generator.samples.add(sample)

    let samples = toSeq(sampleToFrames(sample, generator.wordProc))
    if samples.len == 2: return

    for i in 0..samples.high:
        if i + 1 > samples.high: break

        let currentFrame = samples[i]
        let nextFrame = samples[i + 1]

        var curModel = generator.model.mgetOrPut(currentFrame, @[])
        if (nextFrame notin curModel):
            generator.model[currentFrame].add(nextFrame)
proc addSample*(generator: MarkovGenerator, samples: seq[string]) =
    ## Adds seqence of strings to samples.
    for sample in samples:
        generator.addSample(sample)

proc getSamples*(generator: MarkovGenerator): seq[string] = generator.samples
    ## Returns all samples of generator.

proc cleanSamples*(generator: MarkovGenerator) =
    ## Removes all string from sequence of samples.
    generator.samples.setLen(0)
    generator.model.clear()

proc newMarkov*(
    samples = newSeq[string](),
    wordProc: MarkovProcessWordProc = (proc (word: string): Option[string] = some word.unicodeStringToLower())
): MarkovGenerator =
    ## Creates an instance of Markov generator.
    result = MarkovGenerator()
    result.model = initTable[string, seq[string]]()
    result.wordProc = wordProc

    for sample in samples:
        result.addSample(sample)

proc generate*(generator: MarkovGenerator, options = newMarkovGenerateOptions()): string =
    ## Generates a string.
    if generator.samples.len == 0:
        raise MarkovEmptyModelError.newException("Sequence of samples is empty")

    var begin: string
    if options.begin.isNone: begin = mrkvStart
    else: begin = mrkvStart & " " & options.begin.get

    let beginningFrames = begin.split(" ")

    for i in 0..options.attempts:
        var attemptResult = beginningFrames
        var currentFrame = attemptResult[^1]

        while currentFrame != mrkvEnd:
            if not generator.model.hasKey(currentFrame):
                raise MarkovNotEnoughSamplesError.newException("Not enough samples to use \"" & beginningFrames[1..^1].join(" ") & "\" as a beginning argument")
            let nextFrame = sample(generator.model[currentFrame])

            attemptResult.add(nextFrame)
            currentFrame = nextFrame

        let stringResult = attemptResult[1..^2].join(" ")

        if options.validator(stringResult) == true:
            return stringResult

    raise MarkovOutOfAttemptsError.newException("Out of attempts")