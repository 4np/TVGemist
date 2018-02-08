//
//  NPOKit.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 23/06/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public class NPOKit {
    open static let shared = NPOKit()
    public static let bundle = Bundle(for: NPOKit.self)
    internal var apiKey = "50405d0c015250575e03090047565957510b575053435a53100e55095f160f12"
    internal var apiURL = URL(string: "https://start-api.npo.nl")
    internal var legacyAPIURL = URL(string: "https://ida.omroep.nl")
    //swiftlint:disable:next force_unwrapping
    internal let timeoutInterval = TimeInterval(exactly: 20)!
    //swiftlint:disable:next force_unwrapping
    internal let cacheInterval = TimeInterval(exactly: 600)!
    public var log: NPOKitLogger?
    
    // legacy token
    internal var legacyToken: Token?
    
    // MARK: Initialization
    
    public init() {
        log?.info("NPOKit initialized.")
    }
}
