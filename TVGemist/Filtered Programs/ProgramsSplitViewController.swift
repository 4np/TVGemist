//
//  ProgramsSplitViewController.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 14/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit

class ProgramsSplitViewController: UISplitViewController {
    fileprivate lazy var backgroundImageView: UIImageView = {
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
        self.view.sendSubview(toBack: imageView)
        
        return imageView
    }()
    
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
}
