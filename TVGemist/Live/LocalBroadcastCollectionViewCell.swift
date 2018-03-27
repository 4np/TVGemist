//
//  LocalBroadcastCollectionViewCell.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 27/03/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import NPOKit

class LocalBroadcastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    static let nibName = "LocalBroadcastCollectionViewCell"
    static let reuseIdentifier = "LocalBroadcastCollectionViewCellIdentifier"
    private var broadcastTask: URLSessionDataTask?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetImage()
        nameLabel.text = nil
        nextLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetImage()
        nameLabel.text = nil
        nextLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // determine the image frame (depending on focus)
        let imageFrame = (isFocused) ? imageView.focusedFrameGuide.layoutFrame : imageView.frame
        
        // determine the channel logo frame
        let channelLogoOrigin = CGPoint(
            x: imageFrame.width + imageFrame.origin.x - logoImageView.frame.width - 8.0,
            y: imageFrame.origin.y + 8.0)
        logoImageView.frame.origin = channelLogoOrigin
        
        // determine the name label frame
        let nameLabelOrigin = CGPoint(x: imageFrame.origin.x, y: imageFrame.height + imageFrame.origin.y + 8.0)
        let nameLabelSize = CGSize(width: imageFrame.width, height: nameLabel.frame.height)
        let nameLabelFrame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
        nameLabel.frame = nameLabelFrame
        
        // determine the next label frame
        let nextLabelOrigin = CGPoint(x: imageFrame.origin.x, y: nameLabelFrame.height + nameLabelOrigin.y + 8.0)
        let nextLabelSize = CGSize(width: imageFrame.width, height: nextLabel.frame.height)
        let nextLabelFrame = CGRect(origin: nextLabelOrigin, size: nextLabelSize)
        nextLabel.frame = nextLabelFrame
    }
    
    // MARK: Configuration
    
    func configure(with broadcast: LocalBroadcast) {
        nameLabel.text = broadcast.name
        // get the image for the current program
        getImage(for: broadcast, andSize: imageView.focusedFrameGuide.layoutFrame.size)
        
        // get the logo
        getChannelLogo(for: broadcast, andSize: logoImageView.focusedFrameGuide.layoutFrame.size)
    }
    
    // MARK: Default image
    
    private func resetImage() {
        imageView.image = UIImage(named: "PlaceholderImage")
        logoImageView.image = nil
    }
    
    // MARK: Focus engine
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        imageView.adjustsImageWhenAncestorFocused = self.isFocused
        setNeedsLayout()
    }
    
    private func getImage(for broadcast: LocalBroadcast, andSize size: CGSize) {
        broadcastTask = NPOKit.shared.fetchImage(for: broadcast) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.broadcastTask else { return }
                let scaledImage = image.aspectScaled(toFill: size)
                self?.imageView.image = scaledImage
            case .failure:
                return
            }
        }
    }
    
    private func getChannelLogo(for broadcast: LocalBroadcast, andSize size: CGSize) {
        logoImageView.image = broadcast.logo?.aspectScaled(toFill: size)
    }
}
