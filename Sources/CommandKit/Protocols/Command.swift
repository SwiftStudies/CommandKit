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
public protocol Command: Runnable, Parametric, Optioned {
    var name:        String { get }
    var description: String { get }
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
        let hasParameters = !self.parameters.isEmpty
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

