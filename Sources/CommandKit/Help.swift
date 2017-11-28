//
//  HelpCommand.swift
//  CommandKit
//
//  Created by Sean Alling on 11/25/17.
//

import Foundation


/**
     Help Command
 */
public class HelpCommand: Command {
    public var name = "help"
    public var description = "Provides help, usage instructions, and a list of options and commands for this command line tool."
    public var options: [String : Option] = [
        "u" : Option("u", verbose: "usage", parameters: [(StringTransform, ParameterOccurences)](), run: { _ in
            print(Tool.main.usage)
        })
    ]
    public var parameters = [(StringTransform, ParameterOccurences)]()
    public var run: ([Any]) -> (Any)! = { _ in
        print(Tool.main.help)
    }
}


/**
     Help Option
 */
public class HelpOption: Option {
    var parent: Command!
    
    init(parent: Command) {
        super.init()
        self.name = "h"
        self.verbose = "help"
        self.shortDescription = "Provides help, usage instructions and a list of any options for the \(self.parent.name.style(.bold)) command."
        self.parameters = [(StringTransform, ParameterOccurences)]()
        self.run = { _ in
            print(self.parent.help)
        }
    }
}

