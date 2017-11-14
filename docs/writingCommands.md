# Writing a Command
**CommandKit** allows you to define your own Commands by conforming an object to the `Command` protocol.

## Command Metadata
When writing commands you must provide several metadata-level fields that give users of your tool some information about what your command does.

Some of these are:
``` swift
var name: String { get }
var description: String { get }
```

From these informational fields and any of the `Option`s and `Parameter`s added to your command auto-generate a pre-formatted `help` and `usage` string that can be displayed to the console/Terminal.
``` swift
public var help: String { ... }
public var usage: String { ... }
```

## Run Closure
The run closure is a "block" of code that will execute should the command be called by the user (or executed via code). This closure can accept parameters via an array of `Argument` object. This array is provided in order of user input, is parsed and transformed (if specified) for use in your run closure. **CommandKit** gives great deference here to the developer to properly use these parameter arguments. Its important to note that these arguments need not be validated because they'll only be passed to your run closure should they meet the requirements specified in the `parameters` property of your command.

### Accepting parameters in a run closure
... is easy! Simply define a variable to capture the passed `Argument` array like so,
``` swift
var run: ([Argument]) -> (Any)! = { parameters in
  ...
  // Do stuff with your parameters here
  ...
}
```

### Ignoring parameters in a run closure
... is also super easy! Use a `_` to simply ignore the passed parameter array.
``` swift
var run: ([Argument]) -> (Any)! = { _ in
  ...
  // Do stuff WITHOUT parameters here
  ...
}
```

For more on topics such as **`Options`** and **`Parameter Requirements`** see the following sections **Adding Options** and **Handling Parameters** respectively.
