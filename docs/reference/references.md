# How a Command Line Tool is run in Swift
**CommandKit** allows you to define your own Commands, Options, and accepted parameters as well as handle translating input into object form for use. In Swift Command Line Tools, the insertion point for your code is `main.swift`. The lifecycle of all your code will execute from this file; akin to C-style Command Line Tools with the `main` function.

# Input Structure

Before we can start creating your own Commands, it is important to know the structure of user input via a Command Line Interface. Arguments input to a CLI are structured like so:

```
tool command -option parameter
```
Options are well, optional — they can be omitted in input if allowed by a command. Similarily, an option or command can accept (or even require) any number of parameters. In **CommandKit**, you can define options and/or commands that require parameter be able to be cast or converted to a particular type; this is done by specifying a transform closure `transform: (String)->(Any)` but more on that later.

# Writing Your First Command


_insert explanation of general Tool lifecycle_

### Making a new Command
To make a new command in your Command Line Tool, simply create a new class that conforms to the `Command` protocol which will require implementation for some key aspects of a command.

All commands require a name and description:

```
    var name: 			String { get }
    var description: 	String { get }
```
The more meaty details that allow commands to do tasks and execute code are provided by specifying a signature of accepted parameters, a run closure, and any options that may accompany a command's functionality.

#### Defining a Run Closure
A run closure is executed if a command's name is input into the CLI. This closure can accept parameters in the form of `[Argument]` if the command's `parameters` array is not nil. Below is an example of a run closure that ignores any supplied parameter input:

```
var run: ([Argument]) -> (Any)! = { _ in
        doSomething()
}
```
And here's an example of a run closure that accepts some parameters:

```
var run: ([Argument]) -> (Any)! = { [Argument] in
        doSomethingWithParameters()
}
```
#### Requiring Some Parameters
Specifying some parameters to be passed to your command's run closure is as easy as adding a tuple to the `parameters` array that. This tuple details both how to transform the string into a type of your choosing and the number of times its required to input as arguments by the user.

`var parameters: [(StringTransform, ParameterOccurances)]`

The `StringTranform` is simply a closure that accepts a string and can return a value of any type of your liking. `ParameterOccurances` is an enum that can have values of: `.one`, `.nRequired(Int)`, or `.multiple` (which allows any number of parameters entered by the user so long as the parameters can be transformed).

The `parameters` array is a serial specification, meaning that it specifies parameter requirements in order. The following snippet is an example that defines two parameters; the first being a string that can be transformed into an Integer and the second parameter that can be tranformed into any String. This specification is explicit and therefore this command can only be executed if these two parameters are provided as input, every other case will fail.

```
var parameters: [(StringTransform, ParameterOccurances)] = [
        ({ Int($0) 	  }, .one),
        ({ String($0) }, .one)
]
```


#### Parameter Caveats

```
    var name: 			String { get }
    var description: 	String { get }
    var options: 		[String: Option] { get set }
    var parameters: 	[(StringTransform, ParameterOccurances)] { get set }
    var run: 			([Argument])->(Any)! { get set }
```



### Argument Input

### Command

###
