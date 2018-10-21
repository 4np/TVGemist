//
//  ProgramsSplitViewController.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 14/12/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import NPOKit

class ProgramsSplitViewController: UISplitViewController {
    private lazy var backgroundImageView: UIImageView = {
        // define frame
        let frame = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        
        // create image view
        let imageView = UIImageView(frame: frame)
        
        // add visual effect view
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = imageView.frame
        imageView.addSubview(visualEffectView)
        
        // add to image view to view
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        return imageView
    }()
    private var task: URLSessionDataTask?
    
    var masterViewController: ProgramsMasterViewController? {
        return viewControllers.first as? ProgramsMasterViewController
    }
    
    var detailViewController: ProgramsDetailViewController? {
        return viewControllers.last as? ProgramsDetailViewController
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredPrimaryColumnWidthFraction = 0.24
        detailViewController?.delegate = self
    }
    
    // MARK: UISplitViewControllerDelegate
}

// MARK: ProgramsDetailViewControllerDelegate
extension ProgramsSplitViewController: ProgramsDetailViewControllerDelegate {
    func didUpdateProgram(withImage image: UIImage?) {
        backgroundImageView.image = image
    }
    
    func setInitialBackgroundIfNeeded(for program: Program) {
        // only continue if the background is still blank
        guard backgroundImageView.image == nil, task == nil else { return }
        
        log.debug("Setting initial background image to \(program)")
        
        let size = backgroundImageView.frame.size
        
        // fetch the low resolution image (we'll be blur-ing it anyway)
        task = NPOKit.shared.fetchCollectionImage(for: program) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.task, self?.backgroundImageView.image == nil else { return }
                self?.backgroundImageView.image = image.aspectScaled(toFill: size)
            case .failure(let error as NPOError):
                log.error("Could not download collection image for program \(program) and size \(size) (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not download collection image for program \(program) and size \(size) (\(error.localizedDescription))")
            }
            
            self?.task = nil
        }
    }
}
