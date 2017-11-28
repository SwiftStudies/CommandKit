//
//  Option.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


/**
     An option object can be added to a Command object to modify the command in some way.
 
 - warning: never manually add a `-h` or `--help` option to a command, this is already built in to the command object
 */
public class Option: Runnable, Parametric {
    public var name:    String
    public var verbose: String
    public var shortDescription: String?
    public var parameters = [(StringTransform, ParameterOccurences)]()
    public var run: ([Any]) -> (Any)!
    
    public init(_ name: String, verbose: String, parameters: [(StringTransform, ParameterOccurences)], run closure: @escaping ([Any]) -> (Any)) {
        self.name = name
        self.verbose = verbose
        self.parameters = parameters
        self.run = closure
    }
    
    internal init() {
        self.name = ""
        self.verbose = ""
        self.run = { _ in return () }
    }
}

