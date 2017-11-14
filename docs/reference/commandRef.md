##### Protocol
#**Command**

###A protocol by which to define new commands in a Command Line Tool. This protocol conforms to: `Runnable` and `Parameterizable` protocols.

###**Topics**
---
#### Command Metadata                
``` swift
var name: String { get }
```
Name of the Command; this will be the same string users will use to invoke your command.

``` swift
var description: String { get }
```
A description of the Command that is displayed to the user from help and usage options.

``` swift
var help: String
```
Is an auto-generated string that contains the help format for your Command.

``` swift
var usage: String
```
Is an auto-generated string that contains the usage instructions for your Command.

---
#### Command Options                
``` swift
var options: [String : Option] { get set }
```
A `Dictionary` of all the `Options` added to a Command.

For more information about adding Options, see the **Adding Options** section.

---
#### Command Parameters                
``` swift
var parameters: [(StringTransform, ParameterOccurances)] { get set }
```
An `Array` of the accepted parameters. This array is explicit, meaning that all parameters are validated in the exact order of this array. Commands only accept parameters in the signature given in this array.

For more information about Parameters, see the **Handling Parameters** section.

---
#### Run Closure                
``` swift
var run: ([Argument]) -> (Any)! { get set }
```
Used to run the `Command` itself. This is a closure that accepts an pre-validated array of parsed `Arguments` and can return any value. (Note: this return value is currently unused).

For more information about run closures, see the **Writing Commands** section.
