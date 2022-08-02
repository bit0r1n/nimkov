import options

type
    MarkovGenerateError* = object of CatchableError
        ## Error of generator (not enough samples)
    MarkovValidator* = proc(str: string): bool
        ## Validator for generator. If generated text doesn't satisfy the validator - it will try to generate a new string, if the number of attempts allows.

    MarkovGenerateOptions* = object of RootObj
        ## Options for generator.
        attempts*: int
        begin*: Option[string]
        validator*: MarkovValidator