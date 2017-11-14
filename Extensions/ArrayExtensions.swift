//
//  ArrayExtensions.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


extension Array where Element == String {
    
    /**
         Returns an array of parsed user input arguments from an array of strings
     */
    internal func parseArguments() -> [Argument] {
        var argumentsToReturn = [Argument]()
        for (index, element) in self.enumerated() {
            if element == Tool.main.name && index == 0 {
                // Tool invocation
                let newArg = Argument(value: element, type: .tool)
                argumentsToReturn.append(newArg)
            }
            else if Tool.main.commands.contains(where: { $0.key == element }) && index == 1 {
                // Command
                let newArg = Argument(value: element, type: .command)
                argumentsToReturn.append(newArg)
            }
            else if element.hasPrefix("-") {
                // Option
                var newValue = element.replacingOccurrences(of: "-", with: "")
                let newArg = Argument(value: newValue, type: .option)
                argumentsToReturn.append(newArg)
            }
            else {
                // Parameter
                let newArg = Argument(value: element, type: .parameter)
                argumentsToReturn.append(newArg)
            }
        }
        return argumentsToReturn
    }
}


extension Array where Element == Argument {
    
    /**
         Determines if the correct `tool` argument is present
     
     - Preconditions:
         (a) must be in index = 0
         (b) must be the same name as the one specified in `Tool.name`
     */
    var isToolArgumentPresent: Bool {
        guard let safeArgument = self.first else { return false }
        return (safeArgument.type == .tool) ? true : false
    }
    
    /**
         Determines if a `command` argumewnt is present and in the proper location
     
     - Preconditions:
         (a) must be in index = 1
     */
    var isCommandArgumentPresent: Bool {
        guard self.count >= 2 else { return false }
        return (self[1].type == .command) ? true : false
    }
    
    /**
         Determines if an `option` is present and in the proper location
     
     - Preconditions:
         (a) must have a `command` at index = 1, AND
         (b) must be in index = 2
     */
    var isOptionArgumentPresent: Bool {
        guard self.count >= 3 else { return false }
        guard (self[1].type == .command) else { return false }
        return (self[2].type == .option) ? true : false
    }
    
    /**
         Determines if `parameters` are present and in the proper location
     
     - Preconditions:
         (a) must be in index >= 2
     */
    var isParameterArgumentPresent: Bool {
        let firstIndex = self.index(where: { $0.type == .parameter })
        guard let safeFirstIndex = firstIndex else { return false }
        return Int(safeFirstIndex) >= 2 ? true : false
    }
    
    /**
         Returns the subset of arguments for a particular type
     */
    func subset(for type: Argument.ParsedType) -> [Argument] {
        return self.filter({ $0.type == type })
    }
    
    /**
         Provides the range at which the parameter arguments are found
     */
    var parameterRange: CountableClosedRange<Int>? {
        let subStartIndex = self.index(where: { $0.type == .parameter })
        guard let safeSubStartIndex = subStartIndex else { return nil }
        
        let subTestArray = self.suffix(from: Int(safeSubStartIndex))
        let testedSubArray = subTestArray.map({ $0.type == .parameter })
        
        if let endSubBound = testedSubArray.index(where: { $0 == false }) {
            var endBound = endSubBound + Int(safeSubStartIndex) - 1
            if endBound > self.endIndex { endBound = self.endIndex }
            return Int(safeSubStartIndex)...endBound
        }
        else {
            let endBound = subTestArray.count + Int(safeSubStartIndex) - 1
            return Int(safeSubStartIndex)...endBound
        }
    }
}
