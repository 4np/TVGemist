//
//  FavoriteEpisode+helpers.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 24/07/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import CoreData

public enum WatchedState: Int {
    case unwatched
    case partially
    case fully
    
    public func asIndicator() -> String {
        switch self {
        case .fully:
            return "⚪︎"
        case.partially:
            return "๏"
        case .unwatched:
            return "⚫︎"
        }
    }
}

extension FavoriteEpisode {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "broadcastDate", ascending: false)]
    }
    
    static var sortedFetchRequest: NSFetchRequest<FavoriteEpisode> {
        let request: NSFetchRequest<FavoriteEpisode> = FavoriteEpisode.fetchRequest()
        request.sortDescriptors = FavoriteEpisode.defaultSortDescriptors
        return request
    }
    
    static var favoriteFetchRequest: NSFetchRequest<FavoriteEpisode> {
        let request = FavoriteEpisode.sortedFetchRequest
        request.predicate = NSPredicate(format: "program.isFavorite == true")
        return request
    }
    
    var watchedState: WatchedState {
        if watched {
            return .fully
        }
        
        if watchedDuration > 120 {
            return .partially
        }
        
        return .unwatched
    }
    
    public func updateWatchedDuration(to interval: TimeInterval) throws {
        setValue(interval, forKey: "watchedDuration")
        setValue((interval >= duration - 120), forKey: "watched")
        try getContext().save()
    }
    
    public func toggleFavorite() throws {
        try program?.toggleFavorite()
    }
    
    public func toggleWatched() throws {
        if watched {
            setValue(0, forKey: "watchedDuration")
        }
        
        setValue(!watched, forKey: "watched")
        try getContext().save()
    }
}
