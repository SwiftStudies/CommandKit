//
//  Version.swift
//  CommandKit
//
//  Created by Sean Alling on 11/27/17.
//

import Foundation


/**
     Version Option
 */
public class VersionOption: Option {
    
    init(_ tool:Tool) {
        super.init()
        self.name = "v"
        self.verbose = "version"
        self.shortDescription = "Provides the current version of the command line tool."
        self.parameters = [(StringTransform, ParameterOccurences)]()
        self.run = { _ in 
            print(tool.version.style(.bold))
        }
    }
}
