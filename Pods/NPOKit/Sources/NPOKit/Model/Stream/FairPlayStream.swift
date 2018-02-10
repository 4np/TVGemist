//
//  FairPlayStream.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 31/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct FairPlayStream: Codable {
    public private(set) var url: URL
    public private(set) var licenseToken: String
    public private(set) var licenseServer: URL
    public private(set) var certificateURL: URL?
    var profile: String
    public private(set) var drm: String
    var ip: String
    var isLegacy: Bool
    var isLive: Bool
    var isCatchupAvailable: Bool
    var heartbeatUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case url
        case licenseToken
        case licenseServer
        case certificateURL = "certificateUrl"
        case profile
        case drm
        case ip
        case isLegacy = "legacy"
        case isLive = "live"
        case isCatchupAvailable = "catchupAvailable"
        case heartbeatUrl
    }
}
