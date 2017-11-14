# Adding Parameter Requirements

There are three states of parameter requirements:

1. **None –** accepts no parameter only
2. **Requires a specific parameter sequence -** sequence defined by the `parameters` array
3. **Accepts a specific parameter sequence OR no parameters at all -** the sequence accepted is defined by the `parameters` array and the empty parameter is noted by the `runsWithoutParameters`.

If the `runsWithoutParameters` flag is set to `true`, the run closure will be called whether the `parameters` array is empty or not.

Unfortunately, currently a parameterizable object can only have one parameter sequence.

## Parameter Occurrences

A parameter sequence is defined by specifying an array of `(StringTransform, ParameterOccurrences)` tuples. Parameters can occur:

* **Once or `.one` –** only one parameter can occur with the accompanying transform in sequence
* **nRequired(Int) –** only the number of times specified, with the accompanying transform in sequence
* **multiple -** any number of parameters can occur, with the accompanying transform in sequence
