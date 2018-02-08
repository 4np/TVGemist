//
//  GHKit+Generics.swift
//  GHKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

extension GHKit {

    // MARK: Fetch model
    
    internal func fetchModel<T: Codable>(ofType type: T.Type, forURL url: URL, postData: Data?, completionHandler: @escaping (Result<T>) -> Void) {
        let task = dataTask(forUrl: url, postData: postData, cachePolicy: .reloadIgnoringLocalCacheData) { (result) in
            let jsonData: Data
            
            // check the request was successful
            switch result {
            case .success(let data, _):
                jsonData = data
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
            
            // decode response
            do {
                let decoder = JSONDecoder()
                if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
                    decoder.dateDecodingStrategy = .iso8601
                }
                
                let element = try decoder.decode(type, from: jsonData)
                completionHandler(.success(element))
            } catch let error {
                completionHandler(.failure(error))
            }
        }
        task?.resume()
    }
    
    // MARK: Data Task
    
    internal func dataTask(forUrl url: URL, postData: Data?, cachePolicy: URLRequest.CachePolicy, completionHandler: @escaping (Result<(Data, URLResponse)>) -> Void) -> URLSessionDataTask? {
        // create request
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: self.timeoutInterval)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // create task
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            // on the main queue as this generally involves UI
            DispatchQueue.main.sync {
                if let error = error {
                    completionHandler(.failure(error))
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let error: GHError = .statusCodeError(httpResponse.statusCode, request)
                    completionHandler(.failure(error))
                } else if let data = data, let response = response {
                    completionHandler(.success((data, response)))
                } else {
                    let error: GHError = .unknownError
                    completionHandler(.failure(error))
                }
            }
        })
    }
}
