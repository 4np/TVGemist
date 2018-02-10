//
//  ImageFetchable.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 10/02/2018.
//

import Foundation

public protocol ImageFetchable {
    var images: ImageContainer { get }
    var collectionImageURL: URL? { get }
    var headerImageURL: URL? { get }
}

extension ImageFetchable {
    // MARK: Image URLs

    public var originalImageURL: URL? {
        // try to return the source in order of preference
        if let source = images.original?.formats.expanded?.source {
            return source
        }
        
        return nil
    }
    
    public var collectionImageURL: URL? {
        // try to return the source in order of preference
        if let source = images.gridTile?.formats.tablet?.source { // generally 320x180
            return source
        } else if let source = images.gridTile?.formats.maf?.source { // generally 384x216
            return source
        } else if let source = images.gridTile?.formats.expanded?.source { // generally 295x166
            return source
        } else if let source = images.laneTile?.formats.tablet?.source { // generally 320x180
            return source
        } else if let source = images.laneTile?.formats.maf?.source { // generally 384x216
            return source
        } else if let source = images.laneTile?.formats.expanded?.source { // generally 295x166
            return source
        }
        
        return nil
    }
    
    public var headerImageURL: URL? {
        // try to return the source in order of preference
        if let source = images.header?.formats.tv?.source {
            return source
        }
        
        return nil
    }
}
