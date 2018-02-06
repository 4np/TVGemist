//
//  LoggerWrapper.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 01/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import NPOKit

// Logging Wrapper
class LoggerWrapper: NPOKitLogger {
    public static let shared = LoggerWrapper()
    
    override func verbose(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
        log.verbose(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
    }
    
    override func debug(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
        log.debug(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
    }
    
    override func info(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
        log.info(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
    }
    
    override func warning(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
        log.warning(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
    }
    
    override func error(_ closure: @autoclosure () -> Any?, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line, userInfo: [String: Any] = [:]) {
        log.error(closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber, userInfo: userInfo)
    }
}
