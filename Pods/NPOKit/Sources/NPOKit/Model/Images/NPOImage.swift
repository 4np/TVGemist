//
//  NPOImage.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

struct NPOImage: Codable {
    var title: String
    var formats: FormatContainer
    
    // We don't really care about these
    var alt: String?
    var source: String?
    var created: Date?
    var updated: Date?
    
    enum CodingKeys: String, CodingKey {
        case title
        case formats
        case alt
        case source
        case created = "createdAt"
        case updated = "updatedAt"
    }
}
