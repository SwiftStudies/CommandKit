//
//  StringExtensions.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


extension String {
    
    /**
         Determines if an input string argument has been "flagged" as an option
     */
    internal var isAnOption: Bool {
        return (self.hasPrefix("-")) || (self.hasPrefix("--")) ? true : false
    }
    
    /**
         Determines if an input string argument has been "flagged" as a verbose option
     */
    var isVerbose: Bool {
        return self.hasPrefix("--") ? true : false
    }
    
    /**
     TODO: This method needs to be tested for validitiy
     
         Detemines if a string can be transformed to an object by the closure given
     */
    internal func isConvertible(by transform: (String)->Any) -> Bool {
        return transform(self) != nil ? true : false
    }
}

