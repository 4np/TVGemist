//
//  NPOKit+LegacyStream.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public extension NPOKit {
    func legacyPlaylist(for item: Item, completionHandler: @escaping (Result<LegacyPlaylist>) -> Void) {
        legacyStream(for: item) { [weak self] (result) in
            switch result {
            case .success(let legacyStream):
                guard let url = legacyStream.hlsItem()?.url else {
                    let error: NPOError = .missingFairplayStream
                    completionHandler(.failure(error))
                    return
                }
                
                self?.fetchModel(ofType: LegacyPlaylist.self, forURL: url, postData: nil, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func legacyStream(for item: Item, completionHandler: @escaping (Result<LegacyStream>) -> Void) {
        getToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.fetchModel(ofType: LegacyStream.self, forLegacyEndpoint: "/app.php/\(item.id)?adaptive=yes&token=\(token.value)", postData: nil, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func getToken(completionHandler: @escaping (Result<Token>) -> Void) {
        // use cached token?
        if let token = self.legacyToken, !token.hasExpired {
            completionHandler(.success(token))
            return
        }
        
        // fetch new token
        fetchModel(ofType: Token.self, forLegacyEndpoint: "/app.php/auth", postData: nil, completionHandler: completionHandler)
    }
}
