##### Enum
#**ParameterOccurances**

###An enum that defines the serial frequency of how many parameters the user may enter.

###**Topics**
---
#### Definition                
``` swift
public enum ParameterOccurances {
    case multiple
    case one
    case nRequired(Int)
}
```
* **`multiple`** — defines a parameter than can occur (in series) _any_ number of times.

* **`one`** — defines a parameter that can only occur once.

* **`nRequired(Int)`** — defines parameter that can occur (in series) only the number of times specified.
