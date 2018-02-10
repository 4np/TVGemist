//
//  NPOKit+Episodes.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 31/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public extension NPOKit {
    
    // MARK: Episodes
    
    func getEpisodePaginator(for item: Item, completionHandler: @escaping Paginator<Episode>.CompletionHandler) -> Paginator<Episode> {
        // define how to fetch paginated data
        let fetchHandler: Paginator<Item>.FetchHandler = { [weak self] (paginator, page, pageSize) in
            //swiftlint:disable:next force_unwrapping
            self?.fetchModel(ofType: ComponentData.self, forEndpoint: "media/series/\(item.id!)/episodes?page=\(page)", postData: nil, completionHandler: { (result) in
                switch result {
                case .success(let componentData):
                    let totalResults = componentData.total
                    let numberOfPages = Int(ceil(Double(totalResults) / Double(pageSize)))
                    paginator.completion(result: .success((componentData.items, numberOfPages, nil)))
                case .failure(let error):
                    paginator.completion(result: .failure(error))
                }
            })
        }
        
        // initialize the paginator
        return Paginator(ofType: Episode.self, pageSize: 20, fetchHandler: fetchHandler, completionHandler: completionHandler)
    }
}
