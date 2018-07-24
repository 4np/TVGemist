//
//  FavoriteManager.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 23/07/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import CoreData
import NPOKit

class FavoriteManager {
    public static let shared = FavoriteManager()
    lazy var context: NSManagedObjectContext = {
        //swiftlint:disable:next force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    private init() {
    }
    
    // https://medium.com/xcblog/core-data-with-swift-4-for-beginners-1fc067cca707
    // https://cocoacasts.com/one-to-many-and-many-to-many-core-data-relationships/
    // https://useyourloaf.com/blog/cleaning-up-core-data-fetch-requests/
    // https://github.com/4np/UitzendingGemist/blob/master/NPOKit/NPOKit/RealmProgram.swift
    // https://github.com/4np/UitzendingGemist/blob/master/NPOKit/NPOKit/RealmEpisode.swift
    // https://github.com/4np/NPOKit/blob/4edbced24e7b5262c0236a9d79b9045ec26b2a39/Sources/NPOKit/Model/Items/Item.swift
    public func getFavoriteProgram(by program: Program) -> FavoriteProgram? {
        guard let id = program.id else { return nil }
        
        // try to fetch the program
        let request: NSFetchRequest<FavoriteProgram> = FavoriteProgram.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        request.returnsObjectsAsFaults = false
        
        guard
            let programs = try? context.fetch(request),
            programs.count > 0
            else {
                return createFavoriteProgram(by: program)
        }
        
        return programs.first
    }
    
    private func createFavoriteProgram(by program: Program) -> FavoriteProgram? {
        let favoriteProgram = FavoriteProgram(context: context)
        favoriteProgram.setValue(program.id, forKey: "id")
        favoriteProgram.setValue(program.title, forKey: "title")
        favoriteProgram.setValue(program.description, forKey: "details")
        favoriteProgram.setValue(false, forKey: "isFavorite")
        favoriteProgram.setValue(0, forKey: "watched")
        
        do {
            try context.save()
            return favoriteProgram
        } catch {
            print("Failed saving program!")
            return nil
        }
    }
    
    public func getFavoriteEpisode(by episode: Episode, for program: Program) -> FavoriteEpisode? {
        guard let id = episode.id else { return nil }
        
        // try to fetch the episode
        let request: NSFetchRequest<FavoriteEpisode> = FavoriteEpisode.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        request.returnsObjectsAsFaults = false
        
        guard
            let episodes = try? context.fetch(request),
            episodes.count > 0
            else {
                return createFavoriteEpisode(by: episode, for: program)
        }
        
        return episodes.first
    }
    
    private func createFavoriteEpisode(by episode: Episode, for program: Program) -> FavoriteEpisode? {
        guard let favoriteProgram = getFavoriteProgram(by: program) else { return nil }

        let favoriteEpisode = FavoriteEpisode(context: context)
        favoriteEpisode.program = favoriteProgram
        favoriteEpisode.setValue(episode.id, forKey: "id")
        favoriteEpisode.setValue(episode.title, forKey: "title")
        favoriteEpisode.setValue(episode.description, forKey: "details")
        favoriteEpisode.setValue(episode.duration, forKey: "duration")
        favoriteEpisode.setValue(0, forKey: "watchedDuration")
        favoriteEpisode.setValue(false, forKey: "watched")
        favoriteEpisode.setValue(episode.broadcastDate, forKey: "broadcastDate")
        
        do {
            try context.save()
            return favoriteEpisode
        } catch {
            print("Failed saving episode!")
            return nil
        }
    }
}
