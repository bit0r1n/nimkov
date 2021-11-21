## Welcome to nimkov Documentation!
## 
## Reference
## =========
## - `formatters` Includes default foramtter, that doesn't format text for resulting text from generator
## 
## - `validators` Includes simple validators,
## such as "return text, that satisfy my limit of words or symbols"
## 
## - `generator` Includes Markov object and it functionally,
## such as preparing Markov generator to work, adding or removing all phrases and generating text
## 
## For getting generated text you should import `options` library and use `get` procedure!
## 
## .. code-block:: nim
##  import options
##
##  let markov = newMarkov()
##
##  markov.addSample("hello world")
##  markov.addSample("world of chains")
##  markov.addSample("world for me")
##
##  markov.prepare()
##
##  echo markov.generate().get

## 
## ----
## 

import nimkov/[
  formatters, validators, typedefs,
  generator
]

export formatters, validators, typedefs, generator