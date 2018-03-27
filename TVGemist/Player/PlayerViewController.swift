//
//  PlayerViewController.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 10/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import AVKit
import NPOKit

// Apple says: Do not subclass AVPlayer​View​Controller. Overriding
// this class’s methods is unsupported and results in undefined behavior.
// However, this class does not override any methods, it only adds new
// behaviour but we need to keep this into mind.
class PlayerViewController: AVPlayerViewController {
    public private(set) var fairPlayStream: FairPlayStream?
    private var playbackItem: Any?
    private var schedule: LiveSchedule?
    private var imageTask: URLSessionDataTask?
    private var shouldUpdateMetadata = true
    private var secondsPlayed: Double = 0.0
    private var subtitles: [SubtitleLine]?
    private var currentSubtitleLineNumber = -1
    
    // display subtitles on top of player
    lazy var subtitleLabel: UILabel = {
        let bounds = self.view.bounds
        let frame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 400.0)
        let label = UILabel()// UILabel(frame: frame)
        
        // label configuration
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 45.0)
        
        // text positioning / wrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        // shadow
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 1.0
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        
        if let overlayView = self.contentOverlayView {
            // add label
            overlayView.addSubview(label)
            
            // layout anchors
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 100.0).isActive = true
            label.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 200.0).isActive = true
            label.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -200.0).isActive = true
            label.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -50.0).isActive = true
        }
        
        return label
    }()
}

// MARK: Playback
extension PlayerViewController {
    public func play(liveBroadcast: LiveBroadcast) {
        self.playbackItem = liveBroadcast
        legacyPlay(liveStream: liveBroadcast.channel.liveStream)
    }
    
    public func play(localBroadcast: LocalBroadcast) {
        self.playbackItem = localBroadcast
        if let url = localBroadcast.url {
            play(url: url)
        } else {
            legacyPlay(liveStream: localBroadcast.liveStream)
        }
    }
    
    private func legacyPlay(liveStream: LiveStream) {
        NPOKit.shared.legacyStream(for: liveStream) { [weak self] (result) in
            switch result {
            case .success(let legacyStream):
                guard let url = legacyStream.url else {
                    log.error("Could not fetch legacy stream")
                    return
                }
                
                self?.play(url: url)
            case .failure(let error as NPOError):
                log.error("Could not fetch legacy stream (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch legacy stream (\(error.localizedDescription))")
            }
        }
    }
    
    public func play(episode: Episode) {
        self.playbackItem = episode
    
        // fetch subtitles in case we need them
        fetchSubtitles(for: episode)
        
        guard Utilities.isFairPlayEnabled else {
            legacyPlay(episode: episode)
            return
        }
        
        NPOKit.shared.fairPlayStream(for: episode) { [weak self] (result) in
            switch result {
            case .success(let fairPlayStream):
                self?.fairPlayStream = fairPlayStream
                //dump(fairPlayStream)
                self?.play(url: fairPlayStream.url)
            case .failure(let error as NPOError):
                log.error("Could not fetch playlist for episode (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch playlist for episode (\(error.localizedDescription))")
            }
        }
    }
    
    private func legacyPlay(episode: Episode) {
        // play the legacy HLS Stream
        NPOKit.shared.legacyPlaylist(for: episode) { [weak self] (result) in
            switch result {
            case .success(let legacyPlaylist):
                self?.play(url: legacyPlaylist.url)
            case .failure(let error as NPOError):
                log.error("Could not fetch playlist for episode (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch playlist for episode (\(error.localizedDescription))")
            }
        }
    }
    
    private func play(url: URL) {
        let asset = AVURLAsset(url: url, options: nil)
        
        let queue = DispatchQueue(label: "eu.osx.tvos.NPO.assetqueue")
        asset.resourceLoader.setDelegate(self, queue: queue)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        let player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .pause
        player.automaticallyWaitsToMinimizeStalling = true
        
        // periodic observer
        let interval = CMTimeMakeWithSeconds(0.5, 60) // half a second
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] (time) in
            self?.secondsPlayed = time.seconds
            self?.displaySubtitle(at: time)
            self?.updateAVMetadata()
        }
        
        self.player = player
        player.play()
    }
}

// MARK: Metadata
extension PlayerViewController {
    private func updateAVMetadata() {
        if let episode = playbackItem as? Episode {
            updateAVMetadata(for: episode)
        } else if let broadcast = playbackItem as? LiveBroadcast {
            updateBroadcastIfNeeded(for: broadcast)
            updateAVMetadata(for: broadcast)
        }
    }
    
    private func updateAVMetadata(for episode: Episode) {
        guard shouldUpdateMetadata else { return }
        
        // we only need to set this one
        shouldUpdateMetadata = false
        
        // construct metadata
        let metadata: [AVMetadataKey: Any?] = [
            .commonKeyTitle: episode.title,
            .commonKeyDescription: episode.description,
            .commonKeyPublisher: episode.broadcasters.joined(separator: ", ")
        ]
        
        // set initial metadata while fetching the image
        player?.currentItem?.externalMetadata = avMetadata(from: metadata)
        
        // and update with artwork (if possible)
        updateAVMetadata(for: episode, alternativeItem: nil, metadata: metadata)
    }
    
    private func updateBroadcastIfNeeded(for broadcast: LiveBroadcast) {
        guard let endDate = schedule?.ends, Date() > endDate else { return }
        
        shouldUpdateMetadata = true
    }
    
    private func updateAVMetadata(for broadcast: LiveBroadcast) {
        guard shouldUpdateMetadata, let currentSchedule = broadcast.currentSchedule else { return }
        
        shouldUpdateMetadata = false
        schedule = currentSchedule
        
        let program = currentSchedule.program
        
        // construct metadata
        var metadata: [AVMetadataKey: Any?] = [
            .commonKeyTitle: program.episodeTitle ?? program.title,
            .commonKeyPublisher: program.broadcasters.joined(separator: ", ")
        ]
        
        if let description = program.description {
            metadata[.commonKeyDescription] = description
        }
        
        // and update with artwork (if possible)
        updateAVMetadata(for: program, alternativeItem: broadcast.channel, metadata: metadata)
    }
    
    private func updateAVMetadata(for item: ImageFetchable, alternativeItem: ImageFetchable?, metadata: [AVMetadataKey: Any?]) {
        // fetch image
        imageTask = NPOKit.shared.fetchCollectionImage(for: item) { [weak self] (result) in
            guard case let .success(image, task) = result, task == self?.imageTask, let strongSelf = self else {
                if let item = alternativeItem {
                    self?.updateAVMetadata(for: item, alternativeItem: nil, metadata: metadata)
                }
                return
            }
            
            var mutableMetadata = metadata
            mutableMetadata[.commonKeyArtwork] = image
            strongSelf.player?.currentItem?.externalMetadata = strongSelf.avMetadata(from: mutableMetadata)
        }
    }
    
    private func avMetadata(from dictionary: [AVMetadataKey: Any?]) -> [AVMetadataItem] {
        var metadata = [AVMetadataItem]()
        
        for (key, value) in dictionary {
            let metadataItem = AVMutableMetadataItem()
            metadataItem.locale = NSLocale.current
            metadataItem.key = key as (NSCopying & NSObjectProtocol)?
            metadataItem.keySpace = .common
            
            switch key {
            case .commonKeyArtwork:
                guard let image = value as? UIImage else { continue }
                metadataItem.dataType = kCMMetadataBaseDataType_JPEG as String
                metadataItem.value = UIImageJPEGRepresentation(image, 1) as (NSCopying & NSObjectProtocol)?
            default:
                guard let text = value as? String else { continue }
                metadataItem.value = text as (NSCopying & NSObjectProtocol)?
            }
            
            metadata.append(metadataItem)
        }
        
        return metadata
    }
}

// MARK: Subtitles
extension PlayerViewController {
    var areSubtitlesEnabled: Bool {
        guard let asset = player?.currentItem?.asset, let mediaSelection = player?.currentItem?.currentMediaSelection else { return false }
        
        for characteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
            guard characteristic == .legible, let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) else { continue }
            let option = mediaSelection.selectedMediaOption(in: group)
            return option != nil
        }

        return false
    }
    
    private func fetchSubtitles(for episode: Episode) {
        // fetch subtitles
        NPOKit.shared.fetchSubtitle(for: episode) { [weak self] (result) in
            switch result {
            case .success(let subtitles):
                self?.subtitles = subtitles
            case .failure(let error as NPOError):
                log.error("Could not fetch playlist for episode (\(error.localizedDescription))")
            case.failure(let error):
                log.error("Could not fetch playlist for episode (\(error.localizedDescription))")
            }
        }
    }
    
    private func displaySubtitle(at time: CMTime) {
        // check if we have subtitles
        guard let subtitles = subtitles, areSubtitlesEnabled else {
            if subtitleLabel.text != nil {
                subtitleLabel.text = nil
            }
            return
        }
        
        // check if we have a subtitle for this time
        guard let line = subtitles.first(where: { $0.to >= time.seconds && $0.from <= time.seconds }) else {
            subtitleLabel.text = nil
            return
        }
        
        // check if this line is already being displayed
        guard line.number > currentSubtitleLineNumber else { return }
        
        log.verbose("subtitle line \(line.number): \(line.text)")
        
        currentSubtitleLineNumber = line.number
        subtitleLabel.text = line.text
    }
}
