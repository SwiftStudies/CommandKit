//
//  StringExtensions.swift
//  CommandKit
//
//  Created by Sean Alling on 11/8/17.
//

import Foundation


extension String {
    
    /**
         Determines if an input string argument has been "flagged" as an option
     */
    internal var isAnOption: Bool {
        return (self.hasPrefix("-")) || (self.hasPrefix("--")) ? true : false
    }
    
    /**
         Determines if an input string argument has been "flagged" as a verbose option
     */
    var isVerbose: Bool {
        return self.hasPrefix("--") ? true : false
    }
    
    /**
     TODO: This method needs to be tested for validitiy
     
         Detemines if a string can be transformed to an object by the closure given
     */
    internal func isConvertible(by transform: (String)->Any) -> Bool {
        return transform(self) != nil ? true : false
    }
    
    public func wrap(width: Int, returnIndent: Int) -> String {
        let numberOfLines = self.count / width
        
        // Early escape condition
        guard numberOfLines >= 1 else { return self }
        
        var stringSegments = self.segmentString(width: width)
        return self.assembleLinedString(with: stringSegments, returnIndent: returnIndent)
    }
    
    /**
         Returns the string ranges that are of the length specified without word-breaking, and removing leading line spaces
     */
    private func segmentString(width: Int) -> [Range<String.Index>] {
        let numberOfLines = self.count / width
        var spliceStartIndex = self.startIndex
        var spliceEndIndex = self.startIndex
        
        // Early escape condition
        guard numberOfLines >= 1 else { return [self.startIndex..<self.endIndex] }
        
        var rangesToReturn = [Range<String.Index>]()
        let wordsInString = self.split(separator: " ")
        var characterCountPosition = 0
        var line = 0
        
        for word in wordsInString {
            characterCountPosition += word.count
            let splitAttempt = (width * line) + width
            
            if characterCountPosition > splitAttempt {
                spliceStartIndex = spliceEndIndex
                spliceEndIndex = self.index(startIndex, offsetBy: splitAttempt + 1)
                var range = spliceStartIndex..<spliceEndIndex
                
                if self[range].hasPrefix(" ") {
                    spliceStartIndex = self.index(spliceStartIndex, offsetBy: 1)
                    range = spliceStartIndex..<spliceEndIndex
                }
                rangesToReturn.append(range)
                line += 1
            }
            characterCountPosition += 1
        }
        
        // Add last range
        if spliceEndIndex < self.endIndex {
            spliceStartIndex = spliceEndIndex
            spliceEndIndex = self.endIndex
            var range = spliceStartIndex..<spliceEndIndex
            
            if self[range].hasPrefix(" ") {
                spliceStartIndex = self.index(spliceStartIndex, offsetBy: 1)
                range = spliceStartIndex..<spliceEndIndex
            }
            rangesToReturn.append(range)
        }
        return rangesToReturn
    }
    
    /**
         Returns a formatted string that is lined with the given ranges with the returnIndent provided
     */
    private func assembleLinedString(with segments: [Range<String.Index>], returnIndent: Int) -> String {
        guard segments.count > 1 else { return self }
        
        var stringToReturn = ""
        let newLineChar = "\n"
        var indent = ""
        
        for _ in 0..<returnIndent {
            indent += " "
        }
        let insertion = newLineChar + indent + "\t"
        
        segments.count
        
        for (index, range) in segments.enumerated() {
            self.distance(from: startIndex, to: range.lowerBound)
            self.distance(from: startIndex, to: range.upperBound)
            
            if index < (segments.count - 1) {
                stringToReturn += self[range] + insertion
            }
            else {
                stringToReturn += self[range]
            }
        }
        return stringToReturn
    }
}

