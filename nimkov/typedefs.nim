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

    MarkovGenerateOptions* = object of RootObj
        ## Options for generator.
        attempts*: Positive
        begin*: Option[string]
        validator*: MarkovValidator
    MarkovProcessWordProc* = proc (word: string): Option[string]
        ## Process word, result string will be added to model, if you don't
        ## want to add word to model - return `none string`. Recommended to lower case always, which is default