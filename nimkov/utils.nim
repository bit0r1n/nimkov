import std/[unicode, tables]

proc unicodeStringToLower*(str: string): string =
    ## Converts any text to lower case.
    result = ""
    for s in runes(str):
        result.add(s.toLower.toUTF8)