//
//  FavoriteProgram+Helpers.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 24/07/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import CoreData

extension FavoriteProgram {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true)]
    }
    
    public func indicator() -> String? {
        return isFavorite ? "♥︎" : ""
    }
    
    static var sortedFetchRequest: NSFetchRequest<FavoriteProgram> {
        let request: NSFetchRequest<FavoriteProgram> = FavoriteProgram.fetchRequest()
        request.sortDescriptors = FavoriteProgram.defaultSortDescriptors
        return request
    }
    
    static var favoriteFetchRequest: NSFetchRequest<FavoriteProgram> {
        let request = FavoriteProgram.sortedFetchRequest
        request.predicate = NSPredicate(format: "isFavorite == true")
        return request
    }
    
    public func toggleFavorite() throws {
        setValue(!isFavorite, forKey: "isFavorite")
        try getContext().save()
    }
}
