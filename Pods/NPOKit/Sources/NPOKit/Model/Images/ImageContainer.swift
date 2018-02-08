//
//  ImageContainer.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation

struct ImageContainer: Codable {
    var original: NPOImage?
    var header: NPOImage?
    var gridTile: NPOImage?
    var laneTile: NPOImage?
    var playerPoster: NPOImage?
    var playerRecommendation: NPOImage?
    var playerPostPlay: NPOImage?
    var searchSuggestion: NPOImage?
    var chromecastPostPlay: NPOImage?
    
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
