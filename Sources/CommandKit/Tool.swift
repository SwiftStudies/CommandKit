//
//  Tool.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


/**
     A singleton object that is used to organize, route, and run your command line tool.
 */
public class Tool {
    public static let main = Tool()
    public var name:        String!
    public var arguments =  [Argument]()
    public var commands  =  [String : Command]()
    
    /**
         An error relating to improper user input
     */
    public enum ArgumentError: Error {
        case invalidToolName
        case commandNotFound(for: String)
        case optionNotFound
        case noCommandProvided
        case parametersNotFound
        case insufficientParameters(requiredOccurence: ParameterOccurences)
        case invalidParameterType
        case tooManyParameters
        case unrecognizedOptionParameterSignature
    }
}


/**
     Fetch Objects for Parsed Argument Types
 */
extension Tool {
    
    /**
         Returns the command the command specified by the user if it matches a command allowed in the `Tool` singlton object.
     
     - throws: If there is no command provided by the user that matches any command in the `Tool` singleton object
     */
    fileprivate func fetchCommand() throws -> Command {
        guard let commandArgument = Tool.main.arguments.subset(for: .command).first else { throw Tool.ArgumentError.noCommandProvided }
        guard let command = Tool.main.commands[commandArgument.value] else { throw Tool.ArgumentError.commandNotFound(for: commandArgument.value)}
        return command
    }
    
    /**
         Returns an option for the given command that matches the option (if present) specified in the `Tool` singleton's array of parsed arguments.
     
     - throws: If the option provided by the user is not found for the command given, `Tool.ArgumentError.optionNotFound`
     */
    fileprivate func fetchOption(for command: Command) throws -> Option {
        guard let optionArgument = Tool.main.arguments.subset(for: .option).first else { throw Tool.ArgumentError.optionNotFound }
        guard let option = command.options.element(of: optionArgument.value, isVerbose: optionArgument.value.isVerbose) else { throw Tool.ArgumentError.optionNotFound }
        return option
    }
    
    /**
         Returns an array of transformed parameters using the parameter requirements in the provided `Parametric` object
     */
    fileprivate func fetchTransformedParameters(with parameterOwner: Parametric) throws -> [Any] {
        guard !parameterOwner.parameters.isEmpty else { throw Tool.ArgumentError.tooManyParameters }
        guard let subsetRange = Tool.main.arguments.parameterRange else { throw Tool.ArgumentError.parametersNotFound }
        
        let preParameters = Tool.main.arguments[subsetRange].map({ Argument(value: $0.value, type: $0.type) })
        let postParameters = try parameterOwner.transformParameters(for: preParameters)
        
        return postParameters
    }
}

/**
     Error Handling
 */
extension Tool {
    
    /**
     */
    internal func handle(_ error: ArgumentError) {
        switch error {
        case .commandNotFound(let incorrectCommand):
            <#code#>
        default:
            <#code#>
        }
    }
}

/**
     User-facing methods
 */
extension Tool {
    
    /**
         
     */
    public func run() {
        do {
            let command = try fetchCommand()
            var parameterOwner: Parametric = command
            var runnablePointer: Runnable = command
            var parameters = [Any]()
            
            if Tool.main.arguments.isOptionArgumentPresent {
                let option = try fetchOption(for: command)
                parameterOwner = option
                runnablePointer = option
            }
            
            if Tool.main.arguments.isParameterArgumentPresent {
                parameters = try fetchTransformedParameters(with: parameterOwner)
            }
            _ = runnablePointer.run(parameters)
        }
        catch {
            
        }
    }
}

