# Adding Options to a Command

Adding options to a command is very straight-forward, options are objects we simply add to the `options` array of a command.

Its important to add options to the command's class definition or in its `init` method to ensure they're included when your command is registered (i.e., added) to the `Tool` singleton.

The **`Option`** object conforms to:

  * `Runnable` – meaning an option can be run via a run closure,
  * `Parameterizable` - an option can have parameter requirements of your choosing,
  * `Named` - an option must have both a short-form `name` and long-form `verbose` name

## Defining an option
In your command instantiate a new option like so,
``` swift
class YourCommand: Command {
  ...
  var options: [String: Option] = [
    "t":  Option("t", verbose: "type", parameters: [({ String($0) }, .one)], run: { parameter in
      guard typeParameter = parameter.first else { throw Tool.ArgumentError.insuffientParameters(requiredParameters: .one) }

      doSomethingForThisType(typeParameter.transformedValue)
    })
  ]
}
```

Here we have an option named "`t`" and "`type`", that accepts one parameter that's transformed into a `String`, and runs a closure that executes the `doSomethingForThisType(...)` method.

We can add as many options as we choose, however its good practice to keep the names of options either one or two letters long (limiting the number of options we can add to 26 or 52) but we are not technologically limited to this maximum. Because the options property of a command is a `Dictionary` all keys and therefore option names must be unique.
