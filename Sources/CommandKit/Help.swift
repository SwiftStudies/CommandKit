//
//  HelpCommand.swift
//  CommandKit
//
//  Created by Sean Alling on 11/25/17.
//

import Foundation

/**
     Help Option
 */
public class HelpOption: Option {
    var parent: Command!
    
    init(parent: Command) {
        super.init("h", verbose: "help", description: "Provides help, usage instructions and a list of any options for the \(parent.name.style(.bold)) command.")

        apply = { (command,_) in
            print(command.help)
        }        
    }
}

