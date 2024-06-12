import std/[ tables, strutils, options, random, sequtils ]
import ./[ utils, constants, objects, typedefs ]

randomize()

# private fields moment
type MarkovGenerator* = ref object
    wordProc: MarkovProcessWordProc
    case kind*: MarkovGeneratorModelType
    of mgtSimple:
        seqModel: Table[string, seq[string]]
    of mgtWeighted:
        weightModel: Table[string, CountTable[string]]

proc filterString(str: string): string =
    var subResult = newSeq[string]()

    for word in str.split(" "):
        if word == mrkvStart or word == mrkvEnd: continue
        subResult.add(word)

    result = subResult.join(" ").strip()

iterator sampleToFrames(sample: string, wordProc: MarkovProcessWordProc): string =
    yield mrkvStart

    for word in sample.split(" "):
        if word == mrkvStart or word == mrkvEnd: continue
        let newWord = wordProc(word)
        if newWord.isSome:
            yield newWord.get()

    yield mrkvEnd

proc add*(generator: MarkovGenerator, sample: string) =
    ## Adds string to samples.
    let samples = toSeq(sampleToFrames(sample, generator.wordProc))
    if samples.len == 2: return

    for i in 0..samples.high:
        if i + 1 > samples.high: break

        let currentFrame = samples[i]
        let nextFrame = samples[i + 1]

        case generator.kind
        of mgtSimple:
            if currentFrame notin generator.seqModel:
                generator.seqModel[currentFrame] = @[]
            generator.seqModel[currentFrame].add(nextFrame)
        of mgtWeighted:
            if currentFrame notin generator.weightModel:
                generator.weightModel[currentFrame] = initCountTable[string]()
            generator.weightModel[currentFrame].inc(nextFrame)
proc add*(generator: MarkovGenerator, samples: seq[string]) =
    ## Adds seqence of strings to samples.
    for sample in samples:
        generator.add(sample)

proc model*(generator: MarkovGenerator): Table[string, CountTable[string]] =
    ## Returns model of generator.
    case generator.kind
    of mgtWeighted:
        result = generator.weightModel
    of mgtSimple:
        for key, value in generator.seqModel:
            result[key] = initCountTable[string]()
            for frame in value:
                result[key][frame] = 1 # always will be 1 since in simple model frames are unique

proc clear*(generator: MarkovGenerator) =
    ## Clears generator.
    case generator.kind
    of mgtSimple:
        generator.seqModel.clear()
    of mgtWeighted:
        generator.weightModel.clear()

proc newMarkov*(
    samples = newSeq[string](),
    wordProc: MarkovProcessWordProc = (proc (word: string): Option[
                    string] = some word.unicodeStringToLower()),
    kind: MarkovGeneratorModelType = mgtSimple
): MarkovGenerator =
    ## Creates an instance of Markov generator.
    result = MarkovGenerator(
        kind: kind,
        wordProc: wordProc
    )

    for sample in samples:
        result.add(sample)

proc generate*(generator: MarkovGenerator, options = newMarkovGenerateOptions()): string =
    ## Generates a string.
    case generator.kind
    of mgtSimple:
        if generator.seqModel.len == 0:
            raise MarkovEmptyModelError.newException("Model is empty")
    of mgtWeighted:
        if generator.weightModel.len == 0:
            raise MarkovEmptyModelError.newException("Model is empty")

    var begin: string
    if options.begin.isNone: begin = mrkvStart
    else:
        let filtered = filterString(options.begin.get())
        begin = if filtered.len > 0: mrkvStart & " " & filtered else: mrkvStart

    let beginningFrames = begin.split(" ")

    for i in 0..options.attempts:
        var attemptResult = beginningFrames
        var currentFrame = attemptResult[^1]

        while currentFrame != mrkvEnd:
            var nextFrame: string
            case generator.kind
            of mgtSimple:
                if currentFrame notin generator.seqModel:
                    raise MarkovNotEnoughSamplesError.newException(
                        "Not enough samples to use \"" &
                        beginningFrames[1..^1].join(" ") &
                        "\" as a beginning argument")

                nextFrame = sample(generator.seqModel[currentFrame])
            of mgtWeighted:
                if currentFrame notin generator.weightModel:
                    raise MarkovNotEnoughSamplesError.newException(
                        "Not enough samples to use \"" &
                        beginningFrames[1..^1].join(" ") &
                        "\" as a beginning argument")

                nextFrame = weightedRandom(
                    generator.weightModel[
                    currentFrame].pairs.toSeq)

            attemptResult.add(nextFrame)
            currentFrame = nextFrame

        let stringResult = attemptResult[1..^2].join(" ")

        if options.validator(stringResult) == true:
            return stringResult

    raise MarkovOutOfAttemptsError.newException("Out of attempts")
