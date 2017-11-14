//
//  Command.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


/**
     An object that represents some kind of command or group of code that can be executed from the terminal
 */
public protocol Command: Runnable, Parametric {
    var name:        String { get }
    var description: String { get }
    var options:     [String : Option] { get set }
    var parameters:  [(StringTransform, ParameterOccurences)] { get set }
    var run:         ([Any])->(Any)! { get set }
}


extension Command {
    public var help: String {
        return ""
    }
    
    public var usage: String {
        return ""
    }
}

