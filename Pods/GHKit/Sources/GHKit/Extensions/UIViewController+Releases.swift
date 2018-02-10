//
//  UIViewController+Releases.swift
//  GHKitPackageDescription
//
//  Created by Jeroen Wesbeek on 07/02/2018.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit

extension UIViewController {
    
    // MARK: Swizzling
    
    static func swizzleViewDidAppear() {
        let _: () = {
            let originalSelector = #selector(UIViewController.viewDidAppear(_:))
            let swizzledSelector = #selector(UIViewController.newViewDidAppear(_:))
            
            guard
                let originalMethod = class_getInstanceMethod(self, originalSelector),
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else {
                    return
            }
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }()
    }
    
    // MARK: Swizzled viewDidAppear
    
    @objc func newViewDidAppear(_ animated: Bool) {
        self.newViewDidAppear(animated)
        
        if GHKit.shared.shouldCheck {
            checkForUpdates()
        }
    }
    
    // MARK: Check for updates
    
    private func checkForUpdates() {
        GHKit.shared.fetchNewGitHubReleases { [weak self] (result) in
            guard case let .success(releases) = result, releases.count > 0, let release = releases.first else { return }

            self?.presentUpdateAlert(for: release, count: releases.count)
        }
    }
    
    private func presentUpdateAlert(for release: GHRelease, count: Int) {
        guard let version = release.version else { return }
        
        // i18n
        let singularTitle = "New release available".localized(withComment: "New release alert title (singular)")
        let pluralTitleFormat = "You are %i releases behind".localized(withComment: "New release alert title (plural)")
        let title = (count > 1) ? String.localizedStringWithFormat(pluralTitleFormat, count) : singularTitle
        let messageFormat = "Version '%@' is available for download at '%@'.\n\n%@".localized(withComment: "New release alert message")
        let message = String.localizedStringWithFormat(messageFormat, version, release.url.absoluteString, release.body)
        
        // create alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "ok".localized(withComment: "OK alert action"), style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        
        // present alert
        present(alertController, animated: true, completion: nil)
    }
}

#endif
