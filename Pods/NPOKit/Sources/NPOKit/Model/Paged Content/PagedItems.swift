//
//  PagedItems.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 29/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct PagedItems: Codable {
    var title: String?
    var components: [Component]?
    //var links: Links
    
    enum CodingKeys: String, CodingKey {
        case title
        case components
        //case links = "_links"
    }
}
