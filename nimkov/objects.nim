import options
from ./typedefs import MarkovGenerateOptions
from ./validators import defaultValidator

proc newMarkovGenerateOptions*(
        attempts = 1;
        begin = none string;
        validator = defaultValidator();
    ): MarkovGenerateOptions =
    ## Creates an options for generator.
    result = MarkovGenerateOptions(
        attempts: attempts,
        begin: begin,
        validator: validator
    )