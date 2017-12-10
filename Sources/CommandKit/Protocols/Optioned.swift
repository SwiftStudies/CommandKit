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
    var customOptions : [Option] {get set}
}

extension Optioned{
    var options : [Option] {
        var finalOptions = customOptions
        
        if let commandSelf = self as? Command {
            finalOptions.append(HelpOption(parent:commandSelf))
        }
        
        return finalOptions
    }
    
    subscript(_ name:String)->Option?{
        for option in options {
            if option.name == name {
                return option
            }
        }
        return nil
    }
}
