//
//  LocalBroadcast.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 27/03/2018.
//

import Foundation

public enum LocalBroadcastType: String, Codable {
    case local, regional
}

public struct LocalBroadcast: Codable {
    public internal(set) var id: String
    public internal(set) var type: LocalBroadcastType
    public internal(set) var name: String
    internal var logoName: String
    public internal(set) var url: URL?
    internal var imageURL: URL?
    
    public var liveStream: LiveStream {
        let imageContainer = ImageContainer(original: nil, header: nil, gridTile: nil, laneTile: nil, playerPoster: nil, playerRecommendation: nil,
                                            playerPostPlay: nil, searchSuggestion: nil, chromecastPostPlay: nil)
        return LiveStream(id: id, title: name, images: imageContainer, quality: nil)
    }
    
    public var logo: UXImage? {
        return UXImage(withName: logoName)
    }
}

extension LocalBroadcast: Equatable { }

public func == (lhs: LocalBroadcast, rhs: LocalBroadcast) -> Bool {
    return lhs.id == rhs.id
}
