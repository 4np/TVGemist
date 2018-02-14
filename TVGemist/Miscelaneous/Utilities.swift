//
//  Utilities.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 02/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation

class Utilities {
    static let shared = Utilities()
    static let isDebug = _isDebugAssertConfiguration()
    static let isFairPlayEnabled = false
    static let areSubtitlesEnabled = false
    
    private init() {
    }
}
