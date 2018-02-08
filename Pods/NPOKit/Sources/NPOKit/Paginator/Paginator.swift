//
//  Paginator.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 29/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public class Paginator<T> where T: Pageable {
    public typealias FetchHandler = (_ paginator: Paginator<T>, _ page: Int, _ pageSize: Int) -> Void
    public typealias CompletionHandler = (Result<(paginator: Paginator, items: [T])>) -> Void
    
    private enum PaginatorRequestStatus {
        case none, inProgress, done
    }
    private var requestStatus: PaginatorRequestStatus = .none
    
    private var fetchHandler: FetchHandler
    private var completionHandler: CompletionHandler
    
    public private(set) var page: Int = 0
    public private(set) var pageSize: Int = 20
    public private(set) var numberOfPages = 100000
    public private(set) var filters: [Filter]?
    
    init<T>(ofType: T.Type,
            pageSize: Int,
            fetchHandler: @escaping FetchHandler,
            completionHandler: @escaping CompletionHandler) where T: Pageable {
        self.pageSize = pageSize
        self.fetchHandler = fetchHandler
        self.completionHandler = completionHandler
    }
    
    public func completion(result: Result<(items: [T], numberOfPages: Int, filters: [Filter]?)>) {
        requestStatus = .done
        
        switch result {
        case .success(let items, let numberOfPages, let filters):
            self.page += 1
            self.numberOfPages = numberOfPages
            self.filters = filters
            completionHandler(.success((self, items)))
        case .failure(let error):
            completionHandler(.failure(error))
        }
    }
    
    public func next() {
        guard page < numberOfPages && requestStatus != .inProgress else { return }
        requestStatus = .inProgress
        fetchHandler(self, page + 1, pageSize)
    }
    
    public func reset() {
        page = 0
    }
}
