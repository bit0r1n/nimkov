import options
from ./typedefs import MarkovGenerateOptions
from ./validators import defaultValidator
from ./formatters import defaultFormatter

proc newMarkovGenerateOptions*(
        attempts = 1;
        begin = none string;
        validator = defaultValidator();
        formatter = defaultFormatter
    ): MarkovGenerateOptions =
    ## Creates an options for generator.
    result = MarkovGenerateOptions(
        attempts: attempts,
        begin: begin,
        validator: validator,
        formatter: formatter
    )