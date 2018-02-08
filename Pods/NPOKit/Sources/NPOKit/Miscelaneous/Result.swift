//
//  Result.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(Error)
}
