//
//  GHError.swift
//  GHKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

public enum GHError: Error {
    case unknownError
    case statusCodeError(Int, URLRequest)
    case notConfiguredError
}

extension GHError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .unknownError:
            return "Unknown error"
        case .statusCodeError(let statusCode, let request):
            return "Unexpected HTTP status code \(statusCode) for \(request)"
        case .notConfiguredError:
            return "You need to configure GHKit before using it"
        }
    }
}
