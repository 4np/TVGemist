//
//  JSONTransformable.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 09/02/2018.
//

import Foundation

internal typealias JSONTransformation = (from: String, to: String)
internal protocol JSONTransformable {
    static var jsonTransformations: [JSONTransformation] { get }
}
