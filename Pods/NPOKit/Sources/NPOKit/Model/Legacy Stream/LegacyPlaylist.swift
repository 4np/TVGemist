//
//  LegacyPlaylist.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct LegacyPlaylist: Codable {
    public private(set) var errorCode = 0
    public private(set) var wait = 0
    public private(set) var url: URL
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case wait
        case url
    }
}
