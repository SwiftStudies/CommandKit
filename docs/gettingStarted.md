# How a Command Line Tool is run in Swift
**CommandKit** allows you to define your own Commands, Options, and accepted parameters as well as handle translating input into object form for use. In Swift Command Line Tools, the insertion point for your code is `main.swift`. The lifecycle of all your code will execute from this file; akin to C-style Command Line Tools with the `main` function.

# Input Structure

Before we can start creating your own Commands, it is important to know the structure of user input via a Command Line Interface. Arguments input to a CLI are structured like so:

```
tool command -option parameter
```
Options are well, optional — they can be omitted in input if allowed by a command. Similarily, an option or command can accept (or even require) any number of parameters. In **CommandKit**, you can define options and/or commands that require parameter be able to be cast or converted to a particular type; this is done by specifying a transform closure `transform: (String)->(Any)` but more on that later.

# Writing Your First Command

Lets create a command that prints the parameters entered as output, a trivial example but one that will clearly illustrate just how easy it is to get started.

**1. Make a new command object —** We begin by conforming our new command object to the command protocol like so,
``` swift
class MyFirstCommand: Command {
    var name: String = "myfirst"
    var description: String = "Prints parameters as output."
    var options: [String: Option] = []()
}
```
Now you'll see some errors here but don't fret, we'll tackle these next.


**2. Accept some parameters —** Now we'll add some parameters to this class. We'll accept any number of parameters to this command, we can do so with the following code,
``` swift
class MyFirstCommand: Command {
    ...
    var parameters: [(StringTransform, ParameterOccurrences)] = [
          ({ String($0) }, .multiple)
    ]
}
```

Let's unpack this, to define a parameter to accept we need two things (a) a `StringTransform` which is a closure that transforms the string input into an object, and (b) a specification of how frequent the parameter is allowed to occur. In our example above, we specify that the parameter may appear `.multiple` times, (i.e., it can appear as many times as the user chooses, so long as it can be transformed). Parameters' occurrences  come in three flavors:

``` swift
public enum ParameterOccurrences {
    case multiple
    case one
    case nRequired(Int)
}
```

**3. Define a run closure —** We've defined out Command and allowed it to accept some parameters but our command doesn't do anything with those quite yet. To remedy this, we'll add a run closure that will execute when the user executes the command from Terminal. Add the following code to our command:

``` swift
class MyFirstCommand: Command {
    ...
    var run: ([Argument]) -> (Any)! = { parameters in

        for (index, element) in parameters {
            print("\(element) is parameter #\(index + 1)")
        }
    }
}
```

**4. Register our command —** Now we'll register our new Command with the our `Tool`. The `Tool` is a singleton object (find out more about singletons here...) from which we register, run, and accept input. Registering is simple, we add an instance of our new Command to the `Tool` so that when it accepts input, it will run as expected. Add the following code to your `main.swift` file:

``` swift
Tool.main.commands["myfirst"] = MyFirstCommand()
```

**5. Run the tool with user input —** Below our register command in `main.swift` add the following line of code:
``` swift
Tool.main.run(CommandLine.arguments)
```


Congrats! You've successfully created your first **CommandKit** powered Command Line Tool. Run and accept test out your new command.

!!! note ""
    To run your command from anywhere in Terminal follow the directions in the **Installing Your Tool** section.
