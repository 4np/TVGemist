//
//  EpisodeCollectionViewCell.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 29/10/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import XCGLogger
import NPOKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchedIndicatorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var broadcastDateLabel: UILabel!
    
    static let nibName = "EpisodeCollectionViewCell"
    static let reuseIdentifier = "EpisodeCollectionViewCellIdentifier"
    static let size = CGSize(width: 375, height: 312)
    private var task: URLSessionDataTask?
    
    var episodeImage: UIImage? {
        return imageView.image
    }
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetImage()
        watchedIndicatorLabel.text = nil
        nameLabel.text = nil
        broadcastDateLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetImage()
        watchedIndicatorLabel.text = nil
        nameLabel.text = nil
        broadcastDateLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // determine the image frame (depending on focus)
        let imageFrame = (isFocused) ? imageView.focusedFrameGuide.layoutFrame : imageView.frame
        
        // determine the watched indicator label frame
        let watchedIndicatorLabelOrigin = CGPoint(x: imageFrame.origin.x, y: imageFrame.origin.y + imageFrame.height + 8.0)
        let watchedIndicatorLabelSize = watchedIndicatorLabel.frame.size
        let watchedIndicatorLabelFrame = CGRect(origin: watchedIndicatorLabelOrigin, size: watchedIndicatorLabelSize)
        watchedIndicatorLabel.frame = watchedIndicatorLabelFrame
        
        // determine the label frame
        let labelOrigin = CGPoint(x: imageFrame.origin.x + watchedIndicatorLabelSize.width + 8.0, y: imageFrame.origin.y + imageFrame.height + 8.0)
        let labelSize = CGSize(width: imageFrame.width - watchedIndicatorLabelSize.width - 8.0, height: nameLabel.frame.height)
        let labelFrame = CGRect(origin: labelOrigin, size: labelSize)
        nameLabel.frame = labelFrame
        
        // determine the broadcast date label frame
        let broadcastDateLabelOrigin = CGPoint(x: imageFrame.origin.x, y: labelOrigin.y + labelSize.height + 8.0)
        let broadcastDateLabelSize = CGSize(width: imageFrame.width, height: broadcastDateLabel.frame.height)
        let broadcastDateLabelFrame = CGRect(origin: broadcastDateLabelOrigin, size: broadcastDateLabelSize)
        broadcastDateLabel.frame = broadcastDateLabelFrame
    }
    
    // MARK: Configuration
    
    func configure(withEpisode episode: Episode, and program: Program?) {
        nameLabel.text = episode.episodeTitle ?? episode.title
        
        if let program = program, let favoriteEpisode = FavoriteManager.shared.getFavoriteEpisode(by: episode, for: program) {
            watchedIndicatorLabel.text = favoriteEpisode.watchedState.asIndicator()
        }
        
        if let broadcastDate = episode.broadcastDate {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "CET")
            dateFormatter.locale = Locale.current
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            broadcastDateLabel.text = dateFormatter.string(from: broadcastDate)
        }
        
        // fetch the image for this episode
        getEpisodeImage(forEpisode: episode, andSize: imageView.focusedFrameGuide.layoutFrame.size)
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
    
    private func getEpisodeImage(forEpisode episode: Item, andSize size: CGSize) {
        task = NPOKit.shared.fetchCollectionImage(for: episode) { [weak self] (result) in
            switch result {
            case .success(let image, let task):
                guard task == self?.task else { return }
                let scaledImage = image.aspectScaled(toFill: size)
                // tint the image red when the program cannot be watched
                self?.imageView.image = (episode.isOnlyOnNPOPlus) ? scaledImage.tint(with: .red) : scaledImage
            case .failure(let error as NPOError):
                log.error("Could not download collection image for episode \(episode) and size \(size) (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not download collection image for episode \(episode) and size \(size) (\(error.localizedDescription))")
            }
        }
    }
}
