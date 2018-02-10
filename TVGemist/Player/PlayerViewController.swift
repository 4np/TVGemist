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

class PlayerViewController: AVPlayerViewController {
    public private(set) var fairPlayStream: FairPlayStream?

    func play(liveStream: LiveStream) {
        legacyPlay(liveStream: liveStream)
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
    
    func play(episode: Episode) {
        guard Utilities.isFairPlayEnabled else {
            legacyPlay(episode: episode)
            return
        }
        
        NPOKit.shared.fairPlayStream(for: episode) { [weak self] (result) in
            switch result {
            case .success(let fairPlayStream):
                self?.fairPlayStream = fairPlayStream
                dump(fairPlayStream)
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
        self.player = player
        player.play()
    }
}
