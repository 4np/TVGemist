//
//  Subtitle.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 11/02/2018.
//

import Foundation

public enum SubtitleType: String, Codable {
    case srt
    case vtt
    case ebu
    case unknown
}

public struct Subtitle: Codable {
    public private(set) var label: String
    public private(set) var language: String
    var url: URL
    public private(set) var isDefault: Bool
    public var type: SubtitleType {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return .unknown }
        let elements = components.path.components(separatedBy: "/")
        let fileName = elements.last
        guard let fileExtension = fileName?.components(separatedBy: ".").last else { return .unknown }
        return SubtitleType(rawValue: fileExtension) ?? .unknown
    }
    
    enum CodingKeys: String, CodingKey {
        case label
        case language
        case url = "src"
        case isDefault = "default"
    }
}
