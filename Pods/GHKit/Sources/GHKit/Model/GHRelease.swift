//
//  GHRelease.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

public struct GHRelease: Codable {
    internal var id: Int64
    public private(set) var url: URL
    public private(set) var tag: String
    public private(set) var name: String
    public private(set) var body: String
    public private(set) var isDraft = false
    public private(set) var isPreRelease = false
    public private(set) var author: GHAuthor
    
    public var version: String? {
        guard let regex = try? NSRegularExpression(pattern: "([0-9.]+)", options: .caseInsensitive) else { return nil }
        
        var version: String?
        
        regex.enumerateMatches(in: tag, options: .anchored, range: NSRange(location: 0, length: tag.count)) { (result, _, _) in
            if let match = result?.range, let range = Range(match, in: tag) {
                version = String(tag[range])
            }
        }
        
        return version
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case url = "html_url"
        case tag = "tag_name"
        case name
        case body
        case isDraft = "draft"
        case isPreRelease = "prerelease"
        case author
    }
}

extension GHRelease: Equatable { }

public func == (lhs: GHRelease, rhs: GHRelease) -> Bool {
    return lhs.id == rhs.id
}
