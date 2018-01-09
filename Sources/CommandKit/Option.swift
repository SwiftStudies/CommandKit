//
//  Option.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation

public protocol OptionDefinition{
    //Definition
    var shortForm : String? {get}
    var longForm  : String {get}
    var description : String {get}
    var parameters : Parameter {get}
    var required : Bool {get}
    var instance : OptionInstance? {get set}
    
}

public extension OptionDefinition{
    mutating func createInstance<T:OptionInstance>(withArguments arguments:Arguments) throws ->T?{
        guard let newInstance = try T(withArguments: arguments, withDefinition:parameterDefinition) else {
            return nil
        }
        
        instance = newInstance
        
        return newInstance
    }
    
    var isSet : Bool {
        return instance != nil
    }
    
    func matches(argument:String)->Bool{
        if argument.hasPrefix("--"){
            if argument.substring(2..<argument.count) == longForm {
                return true
            }
        } else if let shortForm = shortForm, argument.hasPrefix("-"){
            if argument.substring(1..<argument.count) == shortForm {
                return true
            }
        }
        
        return false
    }
}

internal extension String {
    internal func substring(_ range:CountableRange<Int>)->Substring{
        let first = index(startIndex, offsetBy: range.startIndex)
        let last = index(first, offsetBy: range.upperBound-range.lowerBound)
        
        return self[first..<last]
    }
}


public extension OptionInstance{
    func parseArguments(withArguments arguments:Arguments, withDefinition definition:RequiredParameters) throws -> [Any]{
        var parsedParameters = [Any]()
        for parameter in definition {
            let max = parameter.cardinality.max
            var i = 0
            repeat {
                guard let argument = arguments.top, argument.type == .parameter else {
                    if max == nil && i > 0{
                        return parsedParameters
                    }
                    throw Argument.ParsingError.insufficientParameters(requiredOccurence: parameter.cardinality)
                }
                
                guard let transformedType = parameter.transform(argument.value) else {
                    throw Argument.ParsingError.incorrectParameterFormat(expected: Void(), actual: argument.value)
                }
                
                parsedParameters.append(transformedType)
                
                
                arguments.consume()
                i += 1
            } while max == nil || max ?? 0<i
        }
        
        return parsedParameters
    }
}

public class Option : OptionDefinition {
    
    public let shortForm: String?
    public let longForm: String
    public let description: String
    
    public let parameterDefinition: RequiredParameters
    
    public let required: Bool
    
    public var instance: OptionInstance?

    public init(shortForm:String? = nil, longForm:String, description:String, parameterDefinition parameters:RequiredParameters, required : Bool = false) {
        self.shortForm = shortForm
        self.longForm = longForm
        self.description = description
        self.parameterDefinition = parameters
        self.required = required
    }
    
    open  func parseArguments(arguments:Arguments) throws {
        try parseArguments(arguments: arguments)
    }
}

