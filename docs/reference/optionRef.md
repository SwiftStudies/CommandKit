##### Class
#**Option**

###An option that can be added to a Command. This class conforms to: `Runnable`, `Parameterizable`, and `Named` protocols.

###**Topics**
---
#### Option Metadata                
``` swift
var name: String
```
Name of the Option; this will be the same string users will use to invoke your an option via short-form and is generally one letter.

``` swift
var verbose: String
```
The long-form or full name of the Option; this will be the same string users will use to invoke your option via long-form (i.e., verbose), generally a word or phrase.

``` swift
var shortDescription: String?
```
A description that briefly describes what this option does in relation to the command. If present, this description is used to auto-generate help and usage messages in the Command that it belongs to when prompted by the user.

---
#### Option Parameters                
``` swift
var parameters: [(StringTransform, ParameterOccurances)]
```
An `Array` of the accepted parameters. This array is explicit, meaning that all parameters are validated in the exact order of this array. Options only accept parameters in the signature given in this array.

For more information about Parameters, see the **Handling Parameters** section.

---
#### Run Closure                
``` swift
var run: ([Argument]) -> (Any)!
```
Used to run the `Option` itself. This is a closure that accepts an pre-validated array of parsed `Arguments` and can return any value. (Note: this return value is currently unused).

---
#### Initialization                
``` swift
init(_ name: String,
    verbose: String,
    parameters: [(StringTransform, ParameterOccurances)],
    run closure: @escaping ([Argument]) -> (Any)
)
```
The initializer for an Option must contain all of the arguments shown above.
