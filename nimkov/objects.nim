import options
import typedefs, validators, formatters

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