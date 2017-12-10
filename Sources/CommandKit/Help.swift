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
    private var tool : Tool
    public var name = "help"
    public var description = "Provides help, usage instructions, and a list of options and commands for this command line tool."
    public var customOptions = [String : Option]()
    public var parameters = [(StringTransform, ParameterOccurences)]()
    public var run: RunBlock 
    
    init(_ tool:Tool){
        self.tool = tool
        customOptions.add(Option("u", verbose: "usage", parameters: [(StringTransform, ParameterOccurences)](), run: { _ in
            print(tool.usage)
        }))
        run = { _ in
            print(tool.help)
        }
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
        self.shortDescription = "Provides help, usage instructions and a list of any options for the \(parent.name.style(.bold)) command."
        self.parameters = [(StringTransform, ParameterOccurences)]()
        self.run = { _ in
            print(self.parent.help)
        }
    }
}

