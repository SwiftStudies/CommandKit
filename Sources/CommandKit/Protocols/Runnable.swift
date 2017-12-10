//
//  Runnable.swift
//  CommandKitPackageDescription
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation

public typealias RunBlock = ([Any]) -> (Any)!

/**
     An object that can be executed by the Tool singleton
 */
public protocol Runnable: Any {
    
    /**
         A run closure is called by the Tool singleton at runtime.
     
     - parameters: Can accept an array of transformed parameters
     - return: Can return a value for use via runnable chaining
     */
    var run: RunBlock { get set }
}

