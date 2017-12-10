//
//  OptionOwner.swift
//  CommandKit
//
//  Created by Sean Alling on 11/28/17.
//

import Foundation


/**
     Defines an object that can accept options
 */
public protocol Optioned {
    
    /**
         An array that holds possible options that can be run
     */
    var customOptions: [String : Option] { get set }
}

extension Optioned{
    var options : [String : Option] {
        var finalOptions = customOptions
        
        if let commandSelf = self as? Command {
            finalOptions.add(HelpOption(parent: commandSelf))
        }
        
        return finalOptions
    }
}
