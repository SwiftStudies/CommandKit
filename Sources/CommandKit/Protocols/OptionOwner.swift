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
public protocol OptionOwner {
    
    /**
         An array that holds possible options that can be run
     */
    var options: [String : Option] { get set }
}

