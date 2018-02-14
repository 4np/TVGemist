//
//  LiveStream.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

public struct LiveStream: Codable, ImageFetchable {
    var id: String
    public private(set) var title: String
    public private(set) var images: ImageContainer
    var quality: [QualityOption]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case images
        case quality = "qualityOptions"
    }
}
