//
//  GHAuthor.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

public struct GHAuthor: Codable {
    internal var id: Int64
    public private(set) var username: String
    public private(set) var avatar: URL?
    public private(set) var url: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case avatar = "avatar_url"
        case url = "html_url"
    }
}

extension GHAuthor: Equatable { }

public func == (lhs: GHAuthor, rhs: GHAuthor) -> Bool {
    return lhs.id == rhs.id
}
