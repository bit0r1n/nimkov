import std/[unicode, tables]

proc unicodeStringToLower*(str: string): string =
    ## Converts any text to lower case.
    result = ""
    for s in runes(str):
        result.add(s.toLower.toUTF8)

proc getRefTableKeys*[T](table: TableRef[T, auto]): seq[T] =
    ## Gets sequence of table keys.
    result = @[]

    for key in table.keys:
        result.add(key)