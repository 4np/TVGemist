//
//  Item.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

/// Typealiases
public typealias Program = Item
public typealias Episode = Item

public enum ItemType: String, Codable {
    case series
    case broadcast
    case fragment
    case playlist
    case unknown
}

public struct Item: Pageable, ImageFetchable {
    var id: String?
    private var itemTitle: String?
    public var title: String {
        // Check if the title was defined
        if let title = self.itemTitle {
            return title
        }
        
        // In the rare occassion the title wasn't defined,
        // try to obtain the title from the images
        return self.images.title ?? "?"
    }
    public private(set) var description: String?
    private var typeName: String
    private var channelName: String?
    public private(set) var genres: [GenreItem]
    public private(set) var broadcasters: [String]
    public private(set) var images: ImageContainer
    
    // type playlist does not return 'isOnlyOnNPOPlus' so we need to wrap it
    private var rawIsOnlyOnNPOPlus: Bool?
    public var isOnlyOnNPOPlus: Bool {
        return rawIsOnlyOnNPOPlus ?? false
    }
    
    // franchise
    var franchiseTitle: String?
    public private(set) var broadcastDate: Date?
    var seasonNumber: Int?
    var episodeNumber: Int?
    public private(set) var episodeTitle: String?
    var duration: TimeInterval?
    
// We don't really care about these:
//    var sterTitle: String
//    var links: ...
//    var shareText: String?
//    var shareURL: URL?
//    var website: URL?
//    var twitter: URL?
//    var facebook: URL?
//    var googlePlus: URL?
//    var pinterest: URL?
//    var instagram: URL?
//    var snapchat: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case itemTitle = "title"
        case description
        case typeName = "type"
        case channelName = "channel"
        case genres
        case broadcasters
        case images
        case rawIsOnlyOnNPOPlus = "isOnlyOnNpoPlus"
        
        // franchise
        case franchiseTitle
        case broadcastDate
        case seasonNumber
        case episodeNumber
        case episodeTitle
        case duration

//        case sterTitle
//        case links = "_links"
//        case shareText
//        case shareURL = "shareUrl"
//        case website = "websiteUrl"
//        case twitter = "twitterUrl"
//        case facebook = "facebookUrl"
//        case googlePlus = "googlePlusUrl"
//        case pinterest = "pinterestUrl"
//        case instagram = "instagramUrl"
//        case snapchat = "snapchatUrl"
    }
}

// MARK: Calculated properties
extension Item {
    
    // MARK: Enums
    
    var type: ItemType {
        return ItemType(rawValue: typeName) ?? .unknown
    }
    
    public var channel: Channel? {
        guard let name = channelName, let channel = Channel(rawValue: name) else { return nil }
        return channel
    }
}

// MARK: CustomDebugStringConvertible

extension Item: CustomDebugStringConvertible {
    public var debugDescription: String {
        let identifier = id ?? "unknown identifier"
        return "'\(title)' (\(identifier))"
    }
}
