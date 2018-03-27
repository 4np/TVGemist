//
//  QualityOption.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

enum QualityOptionType: String, Codable {
    case highest = "Hoogste"
    case high = "Hoog"
    case medium = "Medium"
    case low = "Laag"
}

struct QualityOption: Codable {
    var bitrate: String
    var type: QualityOptionType
    var resolution: String
    var platform: String
    
    enum CodingKeys: String, CodingKey {
        case bitrate
        case type = "label"
        case resolution
        case platform
    }
}
