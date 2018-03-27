//
//  NPOKit+Programs.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 28/06/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

internal enum Genre: String {
    case none = ""
    case documentary = "documentaire"
    case movie = "film"
    case youth = "jeugd"
    case series = "serie"
    case sport
    case music = "muziek"
    case amusement
    case informative = "informatief"
    
    static func all() -> [Genre] {
        return [.documentary, .movie, .youth, .series, .sport, .music, .amusement, .informative]
    }
}

public extension NPOKit {
    
    // MARK: Programs

    func getProgramPaginator(completionHandler: @escaping Paginator<Program>.CompletionHandler) -> Paginator<Program> {
        return getProgramPaginator(using: nil, completionHandler: completionHandler)
    }
    
    func getProgramPaginator(using programFilters: [ProgramFilter]?, completionHandler: @escaping Paginator<Program>.CompletionHandler) -> Paginator<Program> {
        // define how to fetch paginated data
        let fetchHandler: Paginator<Item>.FetchHandler = { [weak self] (paginator, page, pageSize) in
            let endpoint = self?.getEndpoint(for: "page/catalogue", page: page, using: programFilters) ?? "page/catalogue?page=\(page)"
            self?.fetchModel(ofType: PagedItems.self, forEndpoint: endpoint, postData: nil) { (result) in
                switch result {
                case .success(let pagedItems):
                    guard let itemData = pagedItems.components?.filter({ $0.type == .grid }).first?.data else {
                        paginator.completion(result: .failure(NPOError.unknownError))
                        return
                    }
                    
                    let totalResults = itemData.total
                    let numberOfPages = Int(ceil(Double(totalResults) / Double(pageSize)))
                    
                    // get the filters
                    let filters = pagedItems.components?.filter({ $0.type == .filter }).first?.filters
                    
                    // filter out unwanted items
                    let unwantedItems: [ItemType] = [.unknown, .playlist, .fragment]
                    let items = itemData.items.filter({ !unwantedItems.contains($0.type) })

                    paginator.completion(result: .success((items, numberOfPages, filters)))
                case .failure(let error):
                    paginator.completion(result: .failure(error))
                }
            }
        }
        
        // initialize the paginator
        return Paginator(ofType: Program.self, pageSize: 20, fetchHandler: fetchHandler, completionHandler: completionHandler)
    }

    // MARK: Endpoint
    
    private func getEndpoint(for base: String, page: Int, using programFilters: [ProgramFilter]?) -> String {
        var endpoint = "\(base)?page=\(page)"

        guard let programFilters = programFilters else { return endpoint }

        for programFilter in programFilters {
            guard let value = programFilter.option.value else { continue }
            
            // set the filter value
            endpoint += "&\(programFilter.filter.argumentName)=\(value)"
            
            // check if this is a date filter
            guard programFilter.filter.argumentName == "dateFrom" else { continue }
            
            // if so, we need to set an end date
            let title = programFilter.option.title
            let dateToValue = (title.contains("Afgelopen") || title.contains("Alle")) ? today : value
            endpoint += "&dateTo=\(dateToValue)"
        }

        return endpoint
    }
    
    // MARK: Today's date
    
    private var today: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let timeZone = TimeZone(abbreviation: "CET") {
            dateFormatter.timeZone = timeZone
        }
        return dateFormatter.string(from: now)
    }
}
