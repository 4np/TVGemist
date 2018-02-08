//
//  NPOKit+Stream.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 31/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public extension NPOKit {
    func stream(for item: Item, completionHandler: @escaping (Result<Stream>) -> Void) {
        // tv payload
        let payload = "{\"profile\":\"hls\",\"viewer\":1061049068313,\"options\":{\"startOver\":false}}"
        let jsonPayloadData = payload.data(using: .utf8)
        fetchModel(ofType: Stream.self, forEndpoint: "media/\(item.id)/stream", postData: jsonPayloadData, completionHandler: completionHandler)
    }
}
