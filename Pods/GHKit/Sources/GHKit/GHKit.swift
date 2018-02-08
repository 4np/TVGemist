//
//  GHKit.swift
//  GHKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#endif

public class GHKit {
    open static let shared = GHKit()
    //swiftlint:disable:next force_unwrapping
    internal let timeoutInterval = TimeInterval(exactly: 20)!
    //swiftlint:disable:next force_unwrapping
    internal var checkInterval: TimeInterval = TimeInterval(exactly: 60 * 60 * 24)! // daily
    internal var lastChecked: Date?
    internal var user: String?
    internal var repository: String?
    internal var bundle: Bundle?
    internal var shouldIncludePreReleases = false
    internal var isFetchingNewReleases = false
    private var applicationVersion: String? {
        return bundle?.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    public var shouldCheck: Bool {
        guard let lastChecked = lastChecked else { return true }

        let checkDate = Date(timeInterval: checkInterval, since: lastChecked)
        let now = Date()
        return now > checkDate
    }
    public var latestRelease: URL? {
        guard let user = user, let repository = repository else { return nil }
        return URL(string: "https://github.com/\(user)/\(repository)/releases/latest")
    }
    private var base: URL? {
        guard let user = user, let repository = repository else { return nil }
        return URL(string: "https://api.github.com/repos/\(user)/\(repository)/")
    }
    
    // MARK: Initialization
    
    internal init() {
        // Method swizzling
        #if os(iOS) || os(tvOS)
        UIViewController.swizzleViewDidAppear()
        #endif
    }
    
    public func configure(withUser user: String, repository: String, shouldIncludePreReleases: Bool, applicationBundle bundle: Bundle, interval: TimeInterval? = nil) {
        self.user = user
        self.repository = repository
        self.bundle = bundle
        self.shouldIncludePreReleases = shouldIncludePreReleases
        
        // interval is optional, it will use the default interval (daily)
        if let interval = interval {
            self.checkInterval = interval
        }
    }
    
    // MARK: Networking
    
    public func fetchNewGitHubReleases(completionHandler: @escaping (Result<[GHRelease]>) -> Void) {
        // make sure we're not already busy
        guard !isFetchingNewReleases else { return }
        
        guard let applicationVersion = applicationVersion else {
            let error = GHError.notConfiguredError
            completionHandler(.failure(error))
            return
        }
        
        let shouldIncludePreReleases = self.shouldIncludePreReleases
        
        // mark that we're busy
        isFetchingNewReleases = true
        
        fetchGitHubReleases { [weak self] (result) in
            self?.isFetchingNewReleases = false
            
            guard case let .success(releases) = result else {
                completionHandler(result)
                return
            }
            
            self?.lastChecked = Date()

            let newReleases = releases.filter({ (release) in
                if !release.isDraft, let version = release.version, applicationVersion.compare(version, options: .numeric) == .orderedAscending {
                    return shouldIncludePreReleases || !release.isPreRelease
                }
                return false
            })
            
            completionHandler(.success(newReleases))
        }
    }
    
    public func fetchGitHubReleases(completionHandler: @escaping (Result<[GHRelease]>) -> Void) {
        guard let url = URL(string: "releases", relativeTo: base) else {
            let error = GHError.notConfiguredError
            completionHandler(.failure(error))
            return
        }
        
        self.fetchModel(ofType: [GHRelease].self, forURL: url, postData: nil, completionHandler: completionHandler)
    }
}
