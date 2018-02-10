//
//  NPOKit+Live.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

public extension NPOKit {
    public func fetchLiveChannels(completionHandler: @escaping (Result<[LiveComponent]>) -> Void) {
        fetchModel(ofType: LiveContainer.self, forEndpoint: "page/live", postData: nil) { (result) in
            switch result {
            case .success(let container):
                // we're really only interested in the now playing components
                let nowPlayingComponents = container.components.filter({ $0.type == .nowPlaying })
                completionHandler(.success(nowPlayingComponents))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
