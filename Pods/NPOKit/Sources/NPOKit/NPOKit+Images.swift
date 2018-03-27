//
//  NPOKit+Images.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 28/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public extension NPOKit {
    
    // MARK: Private methods
    
    private func fetchImage(url: URL, completionHandler: @escaping (Result<(UXImage, URLSessionDataTask)>) -> Void) -> URLSessionDataTask? {
        return fetchImage(url: url, cachePolicy: .returnCacheDataElseLoad, completionHandler: completionHandler)
    }
    
    private func fetchImage(url: URL, cachePolicy: URLRequest.CachePolicy, completionHandler: @escaping (Result<(UXImage, URLSessionDataTask)>) -> Void) -> URLSessionDataTask? {
        let request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: cacheInterval)
        let session = URLSession.shared
        var task: URLSessionDataTask!
        task = session.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.sync {
                if let error = error {
                    completionHandler(.failure(error))
                } else if let data = data, let image = UXImage(data: data) {
                    completionHandler(.success((image, task)))
                } else {
                    let error: NPOError = .missingImage
                    completionHandler(.failure(error))
                }
            }
        }
        
        // execute task
        task.resume()
        
        return task
    }
    
    // MARK: Public API
    
    func fetchOriginalImage(for item: ImageFetchable, completionHandler: @escaping (Result<(UXImage, URLSessionDataTask)>) -> Void) -> URLSessionDataTask? {
        guard let url = item.originalImageURL else {
            let error = NPOError.imageNotAvailable
            completionHandler(.failure(error))
            return nil
        }
        return fetchImage(url: url, completionHandler: completionHandler)
    }
    
    func fetchCollectionImage(for item: ImageFetchable, completionHandler: @escaping (Result<(UXImage, URLSessionDataTask)>) -> Void) -> URLSessionDataTask? {
        guard let url = item.collectionImageURL else {
            let error = NPOError.imageNotAvailable
            completionHandler(.failure(error))
            return nil
        }
        return fetchImage(url: url, completionHandler: completionHandler)
    }
    
    func fetchHeaderImage(for item: ImageFetchable, completionHandler: @escaping (Result<(UXImage, URLSessionDataTask)>) -> Void) -> URLSessionDataTask? {
        guard let url = item.headerImageURL else {
            let error = NPOError.imageNotAvailable
            completionHandler(.failure(error))
            return nil
        }
        return fetchImage(url: url, completionHandler: completionHandler)
    }
    
    func fetchImage(for broadcast: LocalBroadcast, completionHandler: @escaping (Result<(UXImage, URLSessionDataTask)>) -> Void) -> URLSessionDataTask? {
        guard let url = broadcast.imageURL else {
            let error = NPOError.imageNotAvailable
            completionHandler(.failure(error))
            return nil
        }
        return fetchImage(url: url, completionHandler: completionHandler)
    }
}
