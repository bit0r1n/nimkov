import std/strutils
from ./typedefs import MarkovValidator

proc defaultValidator*(): MarkovValidator = (proc (str: string): bool = true)
    ## Default validator for text. It always returns "true".

proc wordsCount*(min = 0, max = Inf.toInt): MarkovValidator =
    ## Validator, based on words count. Returns true, if count of words satisfy configured limits.
    (proc (str: string): bool = str.split(" ").len >= min and str.split(" ").len <= max)

proc symbolsCount*(min = 0, max = Inf.toInt): MarkovValidator =
    ## Validator, based on symbols count. Returns true, if count of symbols satisfy configured limits.
    (proc (str: string): bool = str.len >= min and str.len <= max)