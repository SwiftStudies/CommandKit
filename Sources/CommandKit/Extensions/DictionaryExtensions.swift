//
//  DictionaryExtensions.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation

// Add a command to the dictionary using its name as the key
public extension Dictionary where Key == String, Value == Command {
    public mutating func add(_ command:Command){
        self[command.name] = command
    }
}

public extension Dictionary where Key == String, Value == Option {
    public mutating func add(_ option:Option){
        self[option.name] = option
    }
}


extension Dictionary where Key == String, Value == Option {
    
    /**
         Returns the option corresponding to the name provided
     */
    func element(of named: String, isVerbose: Bool) -> Option? {
        if isVerbose {
            return self.filter({ $0.value.verbose == named }).first?.value
        }
        else if let returnable = self[named] {
            return returnable
        }
        else {
            return nil
        }
    }
}


extension Dictionary where Key == String {
    
    /**
     */
    var numberOfTabs: Int {
        let keys = self.map({ $0.key })
        let largestKey = keys.reduce(into: "", { largest, newValue in
            largest = newValue.count > largest.count ? newValue : largest
        })
        let rawNumberOfTabs = largestKey.count / 4
        let modulo = 10 % rawNumberOfTabs
        return (modulo == 0) ? (rawNumberOfTabs + 1) : rawNumberOfTabs
    }
}

