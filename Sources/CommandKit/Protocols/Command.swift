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
public protocol Command: Runnable, Parametric,Optioned {
    var name:        String { get }
    var description: String { get }
    
    var customOptions : [Option] { get} 
}

extension Command {
    func execute(withArguments arguments:Arguments) throws ->Int{
        
        //While we still have options to process
        while let nextOption = arguments.top, nextOption.type == .option {
            guard let option = self[nextOption.value] else {
                throw Tool.ArgumentError.optionNotFound
            }
            
            arguments.consume()
            
            try option.parse(arguments: arguments)
            try option.apply?(self, option.parameters)
        }
        
        return run(arguments)
    }
}

extension Command {
        
    /**
         Returns a string with the auto-generated usage schema and a list of options (if present)
     */
    public var help: String {
        let numberOfTabs = options.numberOfTabs
        let lineWidth = 70
        
        return usageParagraph(maxLineWidth: lineWidth) + optionsParagraph(nOptionTabs: numberOfTabs, maxLineWidth: lineWidth)
    }
    
    /**
         Returns a string with the auto-generated usage schema
     */
    public var usage: String {
        let lineWidth = 70
        return usageParagraph(maxLineWidth: lineWidth)
    }
    
    /**
         Returns the formatted usage schema
     */
    private func usageParagraph(maxLineWidth: Int) -> String {
        let title  = "Usage:".style(.underline)
        var schema = "\(Tool.executableName) \(self.name)"
        let returnIndent = 4
        
        let hasOptions = !self.options.isEmpty
        let hasParameters = !self.requiredParameters.isEmpty
        switch (hasOptions, hasParameters) {
        case (true, true):
            schema += " OPTION | PARAMETER(s)"
        case (true, false):
            schema += " OPTION"
        case (false, true):
            schema += " PARAMETER(s)"
        case (false, false):
            break
        }
        schema = schema.color(.green)
        
        if !self.description.isEmpty {
            return title + "\n\n\t$ " + schema + "\n\n\t  " + self.description.wrap(width: (maxLineWidth - returnIndent), returnIndent: returnIndent) + "\n"
        }
        else {
            return title + "\n\n\t$ " + schema + "\n\n"
        }
    }
    
    /**
         Returns a formatted list of options
     */
    private func optionsParagraph(nOptionTabs: Int, maxLineWidth: Int) -> String {
        guard !self.options.isEmpty else { return "" }
        
        let title = "Options:".style(.underline)
        let descriptionWidth = maxLineWidth - (nOptionTabs * 4)
        var optionsParagraph = title + "\n\n"
        
        for option in options {
            optionsParagraph += "\t" + "--\(option.name)".color(.magenta)
                        
            for _ in 0..<(maxLineWidth - option.name.count) {
                optionsParagraph += " "
            }
            optionsParagraph += option.shortDescription.wrap(width: descriptionWidth, returnIndent: (maxLineWidth - descriptionWidth)) + "\n"
        }
        return optionsParagraph
    }
}

