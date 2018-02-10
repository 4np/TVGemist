//
//  LiveContainer.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

struct LiveContainer: Codable, JSONTransformable {
    static var jsonTransformations: [JSONTransformation] = [
        (from: "\"epg\":{", to: "\"epg_singular\":{"),
        (from: "\"epg\":[", to: "\"epg_plural\":[")
    ]
    
    var components: [LiveComponent]
}
