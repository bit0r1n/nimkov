import options

type
    MarkovPrepareStatuses* = enum
        ## Statuses of preparing process
        mrkvPrepareEmptySamples, mrkvPrepareReady
    MarkovGenerateError* = object of CatchableError
        ## Error of generator (not enough samples, generator is not prepared)
    MarkovValidator* = proc(str: string): bool
        ## Validator for generator. If generated text doesn't satisfy the validator - it will try to generate a new string, if the number of attempts allows.
    MarkovFormatter* = proc(str: string): string
        ## Formatter for generator. Formats text if it generated

    MarkovGenerateOptions* = object of RootObj
        ## Options for generator
        attempts*: int
        begin*: Option[string]
        validator*: MarkovValidator
        formatter*: MarkovFormatter