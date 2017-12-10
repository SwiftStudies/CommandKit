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
        super.init("v", verbose: "version", description: "Provides the current version of the command line tool", required: false){
            [weak tool] (_,_) in
            if let tool = tool {
                print(tool.version.style(.bold))
            } else {
                print("Unknown version")
            }
        }
    }
}
