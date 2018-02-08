//
//  NPOError.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

public enum NPOError: Error {
    case unknownError
    case statusCodeError(Int, URLRequest)
    case missingFairplayStream
    case missingImage
}

extension NPOError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .unknownError:
            return "Unknown error"
        case .statusCodeError(let statusCode, let request):
            return "Unexpected HTTP status code \(statusCode) for \(request)"
        case .missingFairplayStream:
            return "Missing FairPlay stream"
        case .missingImage:
            return "Missing image"
        }
    }
}
