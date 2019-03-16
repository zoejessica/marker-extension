//
//  SourceEditorExtension.swift
//  MarkerExtension
//
//  Created by Zoe Smith on 15/3/19.
//  Copyright © 2019 Hot Beverage. All rights reserved.
//

import Foundation
import XcodeKit
import os.log

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
        
    func extensionDidFinishLaunching() {
        os_log("Extension ready", type: .debug)
    }
 
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        let namespace = Bundle(for: type(of: self)).bundleIdentifier!
        let marker = MarkerCommand.className()
        return [[.identifierKey: namespace + marker,
                 .classNameKey: marker,
                 .nameKey: NSLocalizedString("Format Marks", comment: "format marks menu item")]]
    }
}
