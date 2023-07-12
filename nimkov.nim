## Welcome to nimkov Documentation!
## 
## Reference
## =========
## - `validators` Includes simple validators, such as "return text, that satisfy my limit of words or symbols"
## 
## - `generator` Includes Markov object and it functionally, such as preparing Markov generator to work, adding or removing all phrases and generating text
## 
## - `typedefs` Includes all types, that used in this library
## 
## Example of usage
## ================
## .. code-block:: nim
##  import nimkov/generator
##
##  let markov = newMarkov()
##
##  markov.addSample("hello world")
##  markov.addSample("world of chains")
##  markov.addSample("world for me")
##  # or
##  markov.addSample(@["hello world", "world of chains", "world for me"])
##
##  echo markov.generate()
## 
## ----
## 

import ./nimkov/[
  validators, typedefs, generator, objects
]

export validators, typedefs, generator, objects
