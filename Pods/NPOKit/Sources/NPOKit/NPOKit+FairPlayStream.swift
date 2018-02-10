//
//  NPOKit+FairPlayStream.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 31/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public extension NPOKit {
    func fairPlayStream(for item: Item, completionHandler: @escaping (Result<FairPlayStream>) -> Void) {
        guard let id = item.id else {
            let error = NPOError.missingIdentifier
            completionHandler(.failure(error))
            return
        }
        
        // tv payload
        let payload = "{\"profile\":\"hls\",\"viewer\":1061049068313,\"options\":{\"startOver\":false}}"
        let jsonPayloadData = payload.data(using: .utf8)
        fetchModel(ofType: FairPlayStream.self, forEndpoint: "media/\(id)/stream", postData: jsonPayloadData, completionHandler: completionHandler)
    }
}
