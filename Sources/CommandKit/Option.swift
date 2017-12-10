//
//  Option.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation

public typealias ApplicationBlock = ((Command,[Any]) throws ->Void)


/**
     An option object can be added to a Command object to modify the command in some way.
 
 - warning: never manually add a `-h` or `--help` option to a command, this is already built in to the command object
 */
open class Option: Parametric {
    public final var name:    String
    public final var verbose: String
    public final var shortDescription: String
    public final var requiredParameters = RequiredParameters()
    public final var parameters = [Any]()
    public final var required : Bool
    public final var apply : ApplicationBlock?
    
    public init(_ name: String, verbose: String, description:String,required:Bool = false, requiredParameters: RequiredParameters = RequiredParameters(), apply closure: ApplicationBlock? = nil) {
        self.name = name
        self.verbose = verbose
        self.requiredParameters = requiredParameters
        self.apply = closure
        self.required = required
        self.shortDescription = description
    }
    
    final func parse(arguments:Arguments) throws{
        for parameter in requiredParameters {
            let max = parameter.cardinality.max
            var i = 0
            repeat {
                guard let argument = arguments.top, argument.type == .parameter else {
                    if max == nil && i > 0{
                        return
                    }
                    throw Tool.ArgumentError.insufficientParameters(requiredOccurence: parameter.cardinality)
                }
                
                guard let transformedType = parameter.transform(argument.value) else {
                    throw Tool.ArgumentError.incorrectParameterFormat(expected: Void(), actual: argument.value)
                }
                
                parameters.append(transformedType)
                
                arguments.consume()
                i += 1
            } while max == nil || max ?? 0<i
        }
    }
}

