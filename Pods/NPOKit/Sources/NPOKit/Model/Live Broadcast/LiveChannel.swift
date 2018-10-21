//
//  LiveChannel.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

enum LiveChannelCategoryType: String, Codable {
    case tv = "primary_tv"
    case radio = "primary_radio"
    case day = "day_tv"
    case themed = "themed_tv"
}

public struct LiveChannel: Codable, ImageFetchable {
    var slug: String
    public private(set) var name: String
    var type: String
    public private(set) var channel: String
    public private(set) var images: ImageContainer
    public private(set) var liveStream: LiveStream?
    var category: LiveChannelCategoryType

    var player: URL?
    var twitter: URL?
    var facebook: URL?
    var external: URL?
    var webcam: URL?
    var radio: URL?
    //var audio: URL?

    var isMCR: Bool
    var regionRestrictions: [String]

    enum CodingKeys: String, CodingKey {
        case slug
        case name
        case type
        case channel
        case images
        case liveStream
        case category

        case player = "playerUrl"
        case twitter = "twitterUrl"
        case facebook = "facebookUrl"
        case external = "externalUrl"
        case webcam = "webcamUrl"
        case radio = "externalRadioUrl"
        //case audio = "audioStreamUrl"

        case isMCR
        case regionRestrictions
    }
}

extension LiveChannel: Equatable { }

public func == (lhs: LiveChannel, rhs: LiveChannel) -> Bool {
    return lhs.name == rhs.name
}
