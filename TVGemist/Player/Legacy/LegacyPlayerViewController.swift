//
//  LegacyPlayerViewController.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import NPOKit

class LegacyPlayerViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    
    var player: AVPlayer! {
        didSet {
            playerView.playerLayer.player = player
        }
    }
    
    var currentTime: Double {
        get {
            return CMTimeGetSeconds(player.currentTime())
        }
        set {
            let newTime = CMTimeMakeWithSeconds(newValue, 1)
            player.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        }
    }
    
    var duration: Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        
        return CMTimeGetSeconds(currentItem.duration)
    }
    
    var rate: Float {
        get {
            return player.rate
        }
        
        set {
            player.rate = newValue
        }
    }
    
    private var playerLayer: AVPlayerLayer? {
        return playerView.playerLayer
    }
    
    // MARK: Lifecycle
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.pause()
    }
    
    // MARK: Playing
    
    func play(playlist: LegacyPlaylist) {
        let asset = AVURLAsset(url: playlist.url, options: nil)
//        let queue = DispatchQueue(label: "eu.osx.tvos.NPO.assetqueue")
//        asset.resourceLoader.setDelegate(self, queue: queue)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .pause
        player.automaticallyWaitsToMinimizeStalling = true
        
        self.player = player
        
        player.play()
    }
}

extension LegacyPlayerViewController: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        log.debug("resource loader...")
        return false
    }
}
