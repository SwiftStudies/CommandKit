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
public class Tool{
    public var defaultCommand : Command
    
    public var name: String {
        return Tool.executableName
    }
    public var description: String {
        return defaultCommand.description
    }
    
    public var run: RunBlock {
        get {
            return defaultCommand.run
        }
        
        set {
            defaultCommand.run = newValue
        }
    }
    public var requiredParameters : RequiredParameters {
        get{
            return defaultCommand.requiredParameters
        }
        
        set {
            defaultCommand.requiredParameters = newValue
        }
    }
    public var parameters : [Any] {
        return defaultCommand.parameters
    }

    public var customOptions : [Option]{
        get {
            return defaultCommand.customOptions
        }
        
        set {
            defaultCommand.customOptions = newValue
        }
    }
    
    public var version:     String
    
    public var commands = [Command]()
    
    /**
         An error relating to improper user input
     */
    public enum ArgumentError: Error {
        case invalidToolName
        case commandNotFound(for: String)
        case optionNotFound
        case noCommandProvided
        case parametersNotFound
        case insufficientParameters(requiredOccurence: Cardinality)
        case invalidParameterType
        case tooManyParameters
        case unrecognizedOptionParameterSignature
        case incorrectParameterFormat(expected:Void, actual:String)
    }
    
    public init(defaultCommand command:Command, version: String ){
        defaultCommand = command
        self.version = version
        defaultCommand.customOptions.append(VersionOption(self))
    }
    
    internal func get(commandNamed commandName:String)->Command? {
        for command in commands {
            if command.name == commandName {
                return command
            }
        }
        
        return nil
    }
    
    internal static var executableName : String {
        return (CommandLine.arguments[0] as NSString).lastPathComponent
    }
}


/**
     Fetch Objects for Parsed Argument Types
 */
extension Tool {
    
//    /**
//         Returns an array of transformed parameters using the parameter requirements in the provided `Parametric` object
//     */
//    fileprivate func fetchTransformedParameters(with parameterOwner: Parametric) throws -> [Any] {
//        guard !parameterOwner.parameters.isEmpty else { throw Tool.ArgumentError.tooManyParameters }
//        guard let subsetRange = arguments.parameterRange else { throw Tool.ArgumentError.parametersNotFound }
//
//        let preParameters = arguments[subsetRange].map({ Argument(value: $0.value, type: $0.type) })
//        let postParameters = try parameterOwner.transformParameters(for: preParameters)
//
//        return postParameters
//    }
}

/**
     Error Handling
 */
extension Tool {
    
    /**
     */
    internal func handle(_ error: ArgumentError) {
        var actionLog = ""
        var remedyLog = ""
        // var askLog = ""
        
        switch error {
        case .invalidToolName:
            // (1) print error that tool name does not match
            actionLog = "Incorrect tool name for: \((name).style(.bold))".color(.red)
            
        case .commandNotFound(let incorrectCommand):
            // (1) format action and remedy logs
            actionLog = "Command provided was not found: ".style(.bold) + incorrectCommand
            actionLog.applyColor(.red)
            remedyLog = "For more information with \(name) run:" + "\(name) help".style(.bold) + " or " + "-h".style(.bold) + " or " + "--help".style(.bold)
            
        case .optionNotFound:
            // (1) print option provided is not a valid option
            actionLog = "Option provided is " + "not".style(.underline) + " a valid option."
            actionLog.applyColor(.red)
            remedyLog = "For more information run:" + "\(name) help".style(.bold) + " or " + "-h".style(.bold) + " or " + "--help".style(.bold)
            
        case .noCommandProvided:
            // (1) print no valid command was provided
            actionLog = "No command was provided.".color(.red)
            
        case .parametersNotFound:
            // (1) print required parameters were not found
            actionLog = "No parameters were found.".color(.red)
            remedyLog = "Please enter parameters for this command|option. For more information run " + "help".style(.bold)
            
        case .insufficientParameters(let requiredFrequency):
            // (1) print required parameters were not found
            actionLog = "Not enough parameters were provided.".color(.red)
            
            var frequencyString = ""
            switch requiredFrequency {
            case .one:
                frequencyString = "one parameter"
            case .multiple:
                frequencyString = "at least one or more parameters"
            case .nRequired(let num):
                frequencyString = "\(num) parameters"
            }
        
            remedyLog = "Please enter \(frequencyString) for this command|option. For more information run " + "help".style(.bold)
            
        case .invalidParameterType:
            // (1) print required parameter could not be tranformed to the correct type
            actionLog = "Invalid parameter type was given.".color(.red)
            remedyLog = "Enter the correct type of parameter. For more information run " + "help".style(.bold)
            
        case .tooManyParameters:
            // (1) too many parameters were provided
            actionLog = "Too many parameters were provided.".color(.red)
            
        case .unrecognizedOptionParameterSignature:
            // (1) print input provided was not recognized
            actionLog = "Unrecognized option and/or parameter signature."
            remedyLog = "For more information run " + "help".style(.bold)
        //TODO: Improve Parameter requirements so that there is more information about what they are supposed to be
        case .incorrectParameterFormat(let expected, let actual):
            actionLog = "Bad parameter \(actual)"
            remedyLog = "For more information run \("help".style(.bold))"
        }
        
        print(actionLog)
        print(remedyLog)
    }
}

/**
     User-facing methods
 */
extension Tool {
    
    /**
         
     */
    public func execute()->Int {
        do {
            let arguments = Arguments(forTool: self)
            
            //The first argument is the executable
            arguments.consume()
            
            let command : Command
            
            if let commandArgument = arguments.top, commandArgument.type == .command {
                arguments.consume()
                guard let requestedCommand = get(commandNamed: commandArgument.value) else {
                    throw ArgumentError.commandNotFound(for: commandArgument.value)
                }
                command = requestedCommand
            } else {
                command = defaultCommand
            }
            
            return try command.execute(withArguments: arguments)
        } catch {
            if let error = error as? ArgumentError {
                handle(error)
            } else {
                print("\(error)")
            }
            return -1
        }
    }
}


/**
     Usage and Help
 */
extension Tool {
    
    /**
         Returns a string with the auto-generated usage schema
     */
    var usage: String {
        let lineWidth = 70
        return usageParagraph(maxLineWidth: lineWidth)
    }
    
    /**
         Returns a string with the auto-generated usage schema, list of commands (if present), and a list of options (if present)
     */
    var help: String {
        let numberOfTabs = (commands.numberOfTabs > defaultCommand.options.numberOfTabs) ? commands.numberOfTabs : defaultCommand.options.numberOfTabs
        let lineWidth = 70
        
        return usageParagraph(maxLineWidth: lineWidth) + commandsParagraph(nCommandTabs: numberOfTabs, maxLineWidth: lineWidth) + optionsParagraph(nOptionTabs: numberOfTabs, maxLineWidth: lineWidth)
    }
    
    /**
         Returns the formatted usage schema
     */
    private func usageParagraph(maxLineWidth: Int) -> String {
        let title  = "Usage:".style(.underline)
        var schema = "\(name) COMMAND"
        let returnIndent = 4
        
        if !defaultCommand.options.isEmpty {
            schema += " | OPTION"
        }
        schema = schema.color(.green)
        
        return title + "\n\n\t$ " + schema + "\n\n\t  " + description.wrap(width: (maxLineWidth - returnIndent), returnIndent: returnIndent) + "\n"
    }
    
    /**
         Returns a formatted list of commands
     */
    private func commandsParagraph(nCommandTabs: Int, maxLineWidth: Int) -> String {
        guard !self.commands.isEmpty else { return "" }
        
        let title = "Commands:".style(.underline)
        let descriptionWidth = maxLineWidth - (nCommandTabs * 4)
        var commandsParagraph = title + "\n\n"
        
        for command in self.commands {
            commandsParagraph += "\t" + "+ \(command.name)".color(.green)
            
            for _ in 0..<(maxLineWidth - command.name.count) {
                commandsParagraph += " "
            }
            commandsParagraph += command.description.wrap(width: descriptionWidth, returnIndent: (maxLineWidth - descriptionWidth)) + "\n"
        }
        return commandsParagraph
    }
    
    /**
         Returns a formatted list of options
     */
    private func optionsParagraph(nOptionTabs: Int, maxLineWidth: Int) -> String {
        guard !defaultCommand.options.isEmpty else { return "" }
        
        let title = "Options:".style(.underline)
        let descriptionWidth = maxLineWidth - (nOptionTabs * 4)
        var optionsParagraph = title + "\n\n"
        
        for option in defaultCommand.options {
            optionsParagraph += "\t" + "--\(option.name)".color(.magenta)
            
            for _ in 0..<(maxLineWidth - option.name.count) {
                optionsParagraph += " "
            }
            optionsParagraph += option.shortDescription.wrap(width: descriptionWidth, returnIndent: (maxLineWidth - descriptionWidth)) + "\n"
        }
        return optionsParagraph
    }
}

