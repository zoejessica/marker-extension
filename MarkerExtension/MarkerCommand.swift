//
//  SourceEditorCommand.swift
//  MarkerExtension
//
//  Created by Zoe Smith on 15/3/19.
//  Copyright © 2019 Hot Beverage. All rights reserved.
//

import Foundation
import XcodeKit

public class MarkerCommand: NSObject, XCSourceEditorCommand {
    
    public func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // There's only one menu command dealt with by this MarkerCommand class
        // so we don't need to use invocation.commandIdentifier to identify it
        replaceLines(in: invocation.buffer.lines, by: formattingMarks)
        completionHandler(nil)
    }
    
    func replaceLines(in lines: NSMutableArray, by replacing: @escaping (String) -> String?) {
        guard let strings = lines as? [String] else {
            return
        }
        let newStrings: [(Int, String)] = strings.enumerated().compactMap {
            let (index, line) = $0
            guard let replacementLine = replacing(line) else {
                return nil
            }
            return (index, replacementLine)
        }
        newStrings.forEach {
            let (index, newString) = $0
            lines[index] = newString
        }
    }
    
    enum Mark: String {
        case todo = "// TODO:"
        case fixme = "// FIXME:"
        case mark = "// MARK:"
        
        init?(_ string: String) {
            guard let mark = Mark.init(rawValue: "// " + string.uppercased() + ":") else {
                return nil
            }
            self = mark
        }
    }
    
    public func formattingMarks(in input: String) -> String? {
        // We're only interested in one possible match per line
        guard let match = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count)).first else {
            return nil
        }
        
        guard let completeMark = Range(match.range(withName: "completemark"), in: input) else {
            return nil
        }
        
        // Bail if the mark is already correctly formatted
        if let _ = Mark(rawValue: String(input[completeMark])) {
            return nil
        }
        
        // Get a well-formatted mark
        guard let mark = Range(match.range(withName: "mark"), in: input),
            let replacement = Mark(String(input[mark]))?.rawValue else {
                return nil
        }
        
        // If there was a trailing colon, collapse any whitespace between it and the mark:
        let colon = Range(match.range(withName: "colon"), in: input)
        let upperBoundForReplacement = colon?.upperBound ?? mark.upperBound
        // Start the lower bound just before the comment slashes to normalize space there too
        let replacementRange = completeMark.lowerBound..<upperBoundForReplacement
        return input.replacingCharacters(in: replacementRange, with: replacement)
    }
}
    
    
let pattern =
#"""
(?xi)
^
\s*
(?<completemark>
//
\s*
(?<mark>
fixme|todo|mark)
( \s* (?<colon>:) | \s+ )
)
"""#
    
/*
 (?xi)               flags to allow spacing in the pattern
 ^                   match only at beginning of string
 \\s*                allow some leading whitespace
 (?<completemark>    capture group so no replacement is returned for a well formed MARK:
 //                  match only comments, not documentation comments
 \\*                 allow some whitespace after comment - this will be normalized to one space
 (?<mark>            capture group for marks
 fixme|todo|mark     case-insensitive matching as per options
 ( \\s* (?<colon>:)  match EITHER optional whitespace followed by a colon, recording the colon for later
 | \\s+ )            OR some whitespace, which will be normalized
 */

let regex = try! NSRegularExpression(pattern: pattern)
