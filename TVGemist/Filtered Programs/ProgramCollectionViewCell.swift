//
//  ProgramCollectionViewCell.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 30/06/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import NPOKit

class ProgramCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var channelLogoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    static let nibName = "ProgramCollectionViewCell"
    static let reuseIdentifier = "ProgramCollectionViewCellIdentifier"
    private var task: URLSessionDataTask?
    
    var programImage: UIImage? {
        return imageView.image
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetImage()
        nameLabel.text = nil
        channelLogoImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // determine the image frame (depending on focus)
        let imageFrame = (isFocused) ? imageView.focusedFrameGuide.layoutFrame : imageView.frame
        
        // determine the channel logo frame
        let channelLogoOrigin = CGPoint(
            x: imageFrame.width + imageFrame.origin.x - channelLogoImageView.frame.width - 8.0,
            y: imageFrame.origin.y + 8.0)
        channelLogoImageView.frame.origin = channelLogoOrigin
        
        // determine the label frame
        let labelOrigin = CGPoint(x: imageFrame.origin.x, y: imageFrame.height + imageFrame.origin.y + 8.0)
        let labelSize = CGSize(width: imageFrame.width, height: nameLabel.frame.height)
        let labelFrame = CGRect(origin: labelOrigin, size: labelSize)
        nameLabel.frame = labelFrame
    }
    
    // MARK: Configuration
    
    func configure(withProgram program: Item) {
        nameLabel.text = program.title
        
        // fetch the image for this program
        getProgramImage(forProgram: program, andSize: imageView.focusedFrameGuide.layoutFrame.size)
        
        // set channel logo image
        if let logo = program.channel?.logo {
            channelLogoImageView.image = logo
        }
    }
    
    // MARK: Default image
    
    private func resetImage() {
        imageView.image = UIImage(named: "PlaceholderImage")
    }
    
    // MARK: Focus engine
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        imageView.adjustsImageWhenAncestorFocused = self.isFocused
        setNeedsLayout()
    }
    
    private func getProgramImage(forProgram program: Item, andSize size: CGSize) {
        task = NPOKit.shared.fetchCollectionImage(for: program) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.task else { return }
                let scaledImage = image.aspectScaled(toFill: size)
                // tint the image red when the program cannot be watched
                self?.imageView.image = (program.isOnlyOnNPOPlus) ? scaledImage.tint(with: .red) : scaledImage
            case .failure(let error as NPOError):
                log.error("Could not download collection image for program \(program) and size \(size) (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not download collection image for program \(program) and size \(size) (\(error.localizedDescription))")
            }
        }
    }
}
