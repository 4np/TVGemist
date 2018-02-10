//
//  ImageContainer.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

public struct ImageContainer: Codable {
    var original: NPOImage?
    var header: NPOImage?
    var gridTile: NPOImage?
    var laneTile: NPOImage?
    var playerPoster: NPOImage?
    var playerRecommendation: NPOImage?
    var playerPostPlay: NPOImage?
    var searchSuggestion: NPOImage?
    var chromecastPostPlay: NPOImage?
    var title: String? {
        if let title = original?.title {
            return title
        } else if let title = header?.title {
            return title
        } else if let title = gridTile?.title {
            return title
        } else if let title = laneTile?.title {
            return title
        } else if let title = playerPoster?.title {
            return title
        } else if let title = playerRecommendation?.title {
            return title
        } else if let title = playerPostPlay?.title {
            return title
        } else if let title = searchSuggestion?.title {
            return title
        } else if let title = chromecastPostPlay?.title {
            return title
        } else {
            return nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case original
        case header
        case gridTile = "grid.tile"
        case laneTile = "lane.tile"
        case playerPoster = "player.poster"
        case playerRecommendation = "player.recommedation"
        case playerPostPlay = "player.post-play"
        case searchSuggestion = "search.suggestion"
        case chromecastPostPlay = "chromecast.post-play"
    }
}
