//
//  Utilities.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 02/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation

class Utilities {
    static let shared = Utilities()
    static let isDebug = _isDebugAssertConfiguration()
    
    private init() {
    }
}
