//
//  Media.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 11/02/2018.
//

import Foundation

public struct Media: Codable {
    var images: ImageContainer
    public private(set) var subtitles: [Subtitle]
    
    enum CodingKeys: String, CodingKey {
        case images
        case subtitles
    }
}
