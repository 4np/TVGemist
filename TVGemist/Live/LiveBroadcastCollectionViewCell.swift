//
//  LiveBroadcastCollectionViewCell.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 10/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import NPOKit

class LiveBroadcastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    static let nibName = "LiveBroadcastCollectionViewCell"
    static let reuseIdentifier = "LiveBroadcastCollectionViewCellIdentifier"
    private var programTask: URLSessionDataTask?
    private var liveChannelTask: URLSessionDataTask?
    private var logoTask: URLSessionDataTask?
    
    var liveChannelImage: UIImage? {
        return imageView.image
    }

    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetImage()
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
    
    func configure(with broadcast: LiveBroadcast) {
        // program title
        nameLabel.text = broadcast.currentSchedule?.program.title.localizedCapitalized
        
        // next program
        if let nextSchedule = broadcast.nextSchedule {
            let nextFormat = "Next: %@ - %@".localized(withComment: "Next: [time] - [program title]")
            nextLabel.text = String.localizedStringWithFormat(nextFormat, nextSchedule.startTime, nextSchedule.program.title)
        }
        
        // get the image for the current program
        getImage(for: broadcast, andSize: imageView.focusedFrameGuide.layoutFrame.size)
        
        // get the channel logo for the current program
        getLiveChannelLogoImage(forLiveChannel: broadcast.channel, andSize: logoImageView.focusedFrameGuide.layoutFrame.size)
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
    
    private func getImage(for broadcast: LiveBroadcast, andSize size: CGSize) {
        guard let program = broadcast.currentSchedule?.program else {
            getLiveChannelImage(forLiveChannel: broadcast.channel, andSize: size)
            return
        }
        
        getProgramImage(forProgram: program, channel: broadcast.channel, andSize: size)
    }
    
    private func getProgramImage(forProgram program: Program, channel: LiveChannel, andSize size: CGSize) {
        programTask = NPOKit.shared.fetchCollectionImage(for: program) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.programTask else { return }
                let scaledImage = image.aspectScaled(toFill: size)
                // tint the image red when the program cannot be watched
                self?.imageView.image = (program.isOnlyOnNPOPlus) ? scaledImage.tint(with: .red) : scaledImage
            case.failure:
                self?.getLiveChannelImage(forLiveChannel: channel, andSize: size)
            }
        }
    }

    private func getLiveChannelImage(forLiveChannel liveChannel: LiveChannel, andSize size: CGSize) {
        liveChannelTask = NPOKit.shared.fetchCollectionImage(for: liveChannel) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.liveChannelTask else { return }
                let scaledImage = image.aspectScaled(toFill: size)
                // tint the image red when the program cannot be watched
                self?.imageView.image = scaledImage
            case .failure(let error as NPOError):
                log.error("Could not download image for live channel \(liveChannel.name) and size \(size) (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not download image for live channel \(liveChannel.name) and size \(size) (\(error.localizedDescription))")
            }
        }
    }
    
    // MARK: Logo Image
    
    private func getLiveChannelLogoImage(forLiveChannel liveChannel: LiveChannel, andSize size: CGSize) {
        logoTask = NPOKit.shared.fetchOriginalImage(for: liveChannel) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.logoTask else { return }
                let scaledImage = image.aspectScaled(toFill: size)
                self?.logoImageView.image = scaledImage
            case .failure(let error as NPOError):
                log.error("Could not download channel logo image for live channel \(liveChannel.name) and size \(size) (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not download channel logo image for live channel \(liveChannel.name) and size \(size) (\(error.localizedDescription))")
            }
        }
    }
}
