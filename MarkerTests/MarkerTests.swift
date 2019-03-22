//
//  MarkerTests.swift
//  MarkerTests
//
//  Created by Zoe Smith on 17/3/19.
//  Copyright © 2019 Hot Beverage. All rights reserved.
//

import XCTest
import XcodeKit

class MarkerTests: XCTestCase {

    let markerCommand = MarkerCommand()
    
    func testNoOps() {
        let tests = ["// TODO: This", "// FIXME: Something else", "// MARK: Not this", "// MARK:- Not this either"]
        let expected: [String?] = [nil, nil, nil, nil]
        XCTAssertEqual(tests.map(markerCommand.formattingMarks), expected)
    }
    
    func testMissingColons() {
        let tests = ["//TODO This", "//FIXME Something else", "//MARK Not this", "//MARK Not this either"]
        let expected: [String?] = ["// TODO: This", "// FIXME: Something else", "// MARK: Not this", "// MARK: Not this either"]
        XCTAssertEqual(tests.map(markerCommand.formattingMarks), expected)
    }
    
    func testCapitalization() {
        let tests = ["//toDo This", "//fixme Something else", "//mark Not this", "//mark: Not this either"]
        let expected: [String?] = ["// TODO: This", "// FIXME: Something else", "// MARK: Not this", "// MARK: Not this either"]
        XCTAssertEqual(tests.map(markerCommand.formattingMarks), expected)
    }
    
    func testIgnoreWordPrefixes() {
        let tests = ["//toDoThis", "//fixmeSomething else", "//marked Not this", "//marked: Not this either"]
        let expected: [String?] = [nil, nil, nil, nil]
        XCTAssertEqual(tests.map(markerCommand.formattingMarks), expected)
    }
    
    func testNormalizeSpacing() {
        let tests = ["//TODO      :             This", "//MARK    :-     This", "//fixme  : good grief"]
        let expected: [String?] = ["// TODO:             This", "// MARK:-     This", "// FIXME: good grief"]
        XCTAssertEqual(tests.map(markerCommand.formattingMarks), expected)
    }
    
    func testIgnoreRandomCode() {
        let tests = ["func somethingFancy() { ",
                     "var markOne: String",
                     "protocol Mark : FancyProtocol",
                     "struct FixMe {"]
        let expected: [String?] = Array(repeating: nil, count: tests.count)
        XCTAssertEqual(tests.map(markerCommand.formattingMarks), expected)
    }

}
