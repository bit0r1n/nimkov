import std/options

type
    MarkovError* = object of CatchableError
    MarkovEmptyModelError* = object of MarkovError
        ## Throws if trying to generate with empty model
    MarkovNotEnoughSamplesError* = object of MarkovError
        ## Throws if not found last word of beginning in model
    MarkovOutOfAttemptsError* = object of MarkovError
        ## Throws if generating is out of attempts

    MarkovValidator* = proc(str: string): bool
        ## Validator for generator. If generated text doesn't satisfy
        ## the validator - it will try to generate a new string, if the number of attempts allows.

    MarkovGeneratorModelType* = enum
        ## Type of model, which will be used in generator.
        ## `mgtSimple` - simple model, which will be generated with equal probability, i.e. model will be `Table[string, seq[string]]`
        ## `mgtWeighted` - weighted model, which will be generated with weighted probability, i.e. model will be `Table[string, Table[string, int]]`
        mgtSimple
        mgtWeighted
    MarkovGenerateOptions* = object of RootObj
        ## Options for generator.
        attempts*: Positive
        begin*: Option[string]
        validator*: MarkovValidator
    MarkovProcessWordProc* = proc (word: string): Option[string]
        ## Process word, result string will be added to model, if you don't
        ## want to add word to model - return `none string`. Recommended to lower case always, which is default