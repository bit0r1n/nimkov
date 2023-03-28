# nimkov
Nim library, that can help you to generate string, based on Markov chains (Markov text generator)

## Installation

`nimble install nimkov`

## Example
```nim
import nimkov/generator

let markov = newMarkov(@["hello world", "world of chains", "world for me"])

echo markov.generate()
```
