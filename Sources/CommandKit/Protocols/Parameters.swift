//
//  Parameters.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


/**
 Defines the number of times a parameter of a particular type can appear.
 */
public enum Cardinality {
    case one
    case nRequired(Int)
    case multiple
    
    var max : Int? {
        switch self {
        case .one:
            return 1
        case .nRequired(let n):
            return n
        case .multiple:
            return nil
        }
    }
}

public typealias StringTransform = (String) -> Any?
public typealias RequiredParameters = [(transform:StringTransform, cardinality: Cardinality)]

/**
     Defines an object that can accept parameter requirements.
 */
public protocol Parametric {
    
    /**
         An array that specifes the serial requirements of acceptable parameters
     */
    var requiredParameters: RequiredParameters { get set }
    var parameters        : [Any] { get }
}


extension Parametric {
    
    /**
         Helper method - find the first index that was not transformed
     */
    fileprivate func findNewArgumentIndex(from transformedArguments: [Any?]) -> Int {
        let truncatedTransformedArguments = transformedArguments[1..<transformedArguments.count].map({$0})
        let newIndex = truncatedTransformedArguments.index(where: { $0 == nil })
        return newIndex == nil ? 0 : newIndex!
    }
    
    /**
         Transforms the remaining `String` arguments with the provided transform closure a specified number of times
     */
    internal func transformArguments(_ remainingArguments: [String], with transform: StringTransform, count: Int) throws -> [Any] {
        guard remainingArguments.count >= count else { throw Tool.ArgumentError.insufficientParameters(requiredOccurence: .nRequired(count)) }
        
        return try remainingArguments[0..<count].map({
            guard let transformed = transform($0) else {
                throw Tool.ArgumentError.invalidParameterType
            }
            return transformed
        })
    }
    
    /**
         Transforms the parameters arguments using the transform(s) and frequency rule(s) of the parametric object's parameters requirements
     
     - warning: Must provide an array of arguments ALL of type `Argument.ParsedType.parameter`
     
     - throws: If any of the supplied parameter arguments do not match any of the requirements specified of the parametric object
     */
    internal func transformParameters(for arguments: [Argument]) throws -> [Any] {
        guard (arguments.contains(where: { $0.type != .parameter }) == false) else { throw Tool.ArgumentError.parametersNotFound }
        var argumentIndex = 0
        var transformedParameters = [Any]()
        
        for parameter in self.requiredParameters {
            let transform = parameter.0
            let frequencyRule = parameter.1
            let remainingArguments = arguments.map({ String($0.value) })
            
            switch frequencyRule {
            case .one:
                // Transform
                let appendable = try transformArguments(remainingArguments, with: transform, count: 1)
                transformedParameters.append(contentsOf: appendable)
                argumentIndex = argumentIndex + 1
                
            case .nRequired(let requiredOccurrences):
                // Transform
                let appendable = try transformArguments(remainingArguments, with: transform, count: requiredOccurrences)
                transformedParameters.append(contentsOf: appendable)
                argumentIndex = argumentIndex + requiredOccurrences
                
            case .multiple:
                // Transform
                let transformedArgs = remainingArguments.map(transform)
                guard transformedArgs.first != nil else { throw Tool.ArgumentError.insufficientParameters(requiredOccurence: .multiple) }
                let remainingUpperBound = findNewArgumentIndex(from: transformedArgs)
                argumentIndex = argumentIndex + remainingUpperBound
                
                let appendable = Array(transformedArgs[0..<remainingUpperBound])
                transformedParameters.append(appendable)
            }
            
            // Early escape condition
            if argumentIndex > arguments.count {
                break
            }
        }
        
        if argumentIndex < arguments.count {
            throw Tool.ArgumentError.tooManyParameters
        }
        return transformedParameters
    }
}

