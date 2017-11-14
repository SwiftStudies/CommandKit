##### Protocol
#**Named**

###A protocol that ensures that an object has a short- and long-form name.

###**Topics**
---
#### Name                
``` swift
var name: String { get set }
var verbose: String { get set }
```
Both the short `name` and long-form `verbose` names are required in this protocol.


##### Protocol
#**Runnable**

###A protocol that ensures an object can be run.

###**Topics**
---
#### Run Closure                
``` swift
var run: ([Argument]) -> (Any)! { get set }
```
A run closure that accepts a pre-validated and parsed array of `Arguments` can returns any value (note: this return value is currently unused). This is where any "work" is done by an `Option` or `Command` or any object that conforms to `Runnable`.


##### Closure
#**StringTransform**

###A closure that transforms a string into an object of choosing.

###**Topics**
---
#### Definition                
``` swift
typealias StringTransform = (String) -> Any
```
A run closure that accepts a one-word string and transforms it into an any specified object. This is used when transforming parameters into object for use in a run closure.
