##### Struct
#**Argument**

###An object that represents some information about a user invoked argument.

###**Topics**
---
#### Values               
``` swift
var value: String
```
The `String` value of the user's input.

``` swift
var transformedValue: Any?
```
The transformed value of the user's input, if the input can be transformed. This value will be of whatever type the transform returns.

#### Parsed Type               
``` swift
var type: ParsedType

enum ParsedType {
    case tool
    case command
    case option
    case parameter
}
```
The kind of `Argument` based on parsing.
