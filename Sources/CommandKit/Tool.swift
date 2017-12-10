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
public class Tool: Command {
    public var name: String {
        return Tool.executableName
    }
    public var description: String
    
    public var run: RunBlock
    public var parameters = [(StringTransform, ParameterOccurences)] ()
    
    public var version:     String!
    public var arguments =  [Argument]()
    public var commands = [String : Command]()
    public var customOptions =  [String : Option]()
    
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
    
    public init(description:String, _ runBlock:@escaping RunBlock){
        self.description = description
        self.run = runBlock
        commands.add(HelpCommand(self))
        customOptions.add(VersionOption(self))
    }
    
    internal static var executableName : String {
        return (CommandLine.arguments[0] as NSString).lastPathComponent
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
        guard let commandArgument = arguments.subset(for: .command).first else { throw Tool.ArgumentError.noCommandProvided }
        guard let command = commands[commandArgument.value] else { throw Tool.ArgumentError.commandNotFound(for: commandArgument.value)}
        return command
    }
    
    /**
         Returns an option for the given command that matches the option (if present) specified in the `Tool` singleton's array of parsed arguments.
     
     - throws: If the option provided by the user is not found for the command given, `Tool.ArgumentError.optionNotFound`
     */
    fileprivate func fetchOption(for owner: Optioned) throws -> Option {
        guard let optionArgument = arguments.subset(for: .option).first else { throw Tool.ArgumentError.optionNotFound }
        guard let option = owner.options.element(of: optionArgument.value, isVerbose: optionArgument.value.isVerbose) else { throw Tool.ArgumentError.optionNotFound }
        return option
    }
    
    /**
         Returns an array of transformed parameters using the parameter requirements in the provided `Parametric` object
     */
    fileprivate func fetchTransformedParameters(with parameterOwner: Parametric) throws -> [Any] {
        guard !parameterOwner.parameters.isEmpty else { throw Tool.ArgumentError.tooManyParameters }
        guard let subsetRange = arguments.parameterRange else { throw Tool.ArgumentError.parametersNotFound }
        
        let preParameters = arguments[subsetRange].map({ Argument(value: $0.value, type: $0.type) })
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
    public func execute() {
        arguments =  CommandLine.arguments.parseArguments(forTool: self)

        do {
            var parameterOwner: Parametric?
            var runnablePointer: Runnable?
            var optionOwner: Optioned = self
            
            if arguments.isCommandArgumentPresent {
                let command = try fetchCommand()
                parameterOwner = command
                runnablePointer = command
                optionOwner = command
            }
            
            var parameters = [Any]()
            
            if arguments.isOptionArgumentPresent {
                let option = try fetchOption(for: optionOwner)
                parameterOwner = option
                runnablePointer = option
            }
            
            if arguments.isParameterArgumentPresent {
                guard let safeParameterOwner = parameterOwner else { throw ArgumentError.noCommandProvided }
                parameters = try fetchTransformedParameters(with: safeParameterOwner)
            }
            guard let safeRunnablePointer = runnablePointer else {
                run([])
                return
            }
            _ = safeRunnablePointer.run(parameters)
        }
        catch {
            guard let runError = error as? ArgumentError else { return }
            handle(runError)
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
        let numberOfTabs = (commands.numberOfTabs > options.numberOfTabs) ? commands.numberOfTabs : options.numberOfTabs
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
        
        if !self.options.isEmpty {
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
        
        for element in self.commands {
            commandsParagraph += "\t" + "+ \(element.key)".color(.green)
            
            for _ in 0..<(maxLineWidth - element.key.count) {
                commandsParagraph += " "
            }
            commandsParagraph += element.value.description.wrap(width: descriptionWidth, returnIndent: (maxLineWidth - descriptionWidth)) + "\n"
        }
        return commandsParagraph
    }
    
    /**
         Returns a formatted list of options
     */
    private func optionsParagraph(nOptionTabs: Int, maxLineWidth: Int) -> String {
        guard !self.options.isEmpty else { return "" }
        
        let title = "Options:".style(.underline)
        let descriptionWidth = maxLineWidth - (nOptionTabs * 4)
        var optionsParagraph = title + "\n\n"
        
        for element in options {
            optionsParagraph += "\t" + "--\(element.key)".color(.magenta)
            
            guard let elementDescription = element.value.shortDescription else { continue }
            
            for _ in 0..<(maxLineWidth - element.key.count) {
                optionsParagraph += " "
            }
            optionsParagraph += elementDescription.wrap(width: descriptionWidth, returnIndent: (maxLineWidth - descriptionWidth)) + "\n"
        }
        return optionsParagraph
    }
}

