##### Class
#**Tool**

###A Singleton for all Tool-related actions.

###**Topics**
---
#### Singleton                
``` swift
static let main =  Tool()
```
Reference to Singleton.

---
#### Parsed Arguments                
``` swift
var arguments =  [Argument]()
```
Access to a parsed copy of the swift arguments, ensure accessing these occurs after the singleton has been instantiated with `CommandLine.arguments`.

For more information of `Argument`, see the **Argument Reference**.

---
#### Registered Commands                
``` swift
var commands =  [String: Command]()
```
Access to all the registered commands in the `Tool`. Here is where you would add/register instances of your commands. It is **_highly recommended_** that you provide keys of your command in this dictionary that directly correspond to your command's name to avoid confusion.

---
#### Error Handling                
``` swift
enum ArgumentError: Error {
    case invalidToolName
    case commandNotFound(for: String)
    case noCommandProvided
    case optionNotFound
    case insufficientParameters(requiredParameters: ParameterOccurances)
    case invalidParameterType(requiredType: Any)
    case unrecognizedOptionParameterSignature
    case tooManyParameters
    case parametersNotFound
}
```
Used for throwing and handling errors related to user input. For more information about error handling, see the **Error Handling** section.
