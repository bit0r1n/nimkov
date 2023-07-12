import std/[unicode, random]

proc unicodeStringToLower*(str: string): string =
    ## Converts any text to lower case.
    result = ""
    for s in runes(str):
        result.add(s.toLower.toUTF8)

proc weightedRandom*[T](weights: openArray[tuple[key: T, weight: int]]): T =
    var totalWeight = 0
    for w in weights:
        totalWeight += w.weight
    var r = rand(totalWeight)
    for w in weights:
        r -= w.weight
        if r < 0:
            return w.key
    result = weights[0].key