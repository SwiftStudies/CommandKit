//
//  Argument.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


/**
     An object that represents a parsed command line interface argument. Every argument is seperated by a single space.
 */
public struct Argument {
    public var value:   String
    public var type:    ParsedType
    
    /**
         Represents the kind or type of Argument
     */
    public enum ParsedType {
        case tool
        case command
        case option
        case parameter
    }
    
    public init(value: String, type: ParsedType) {
        self.value = value
        self.type = type
    }
}

