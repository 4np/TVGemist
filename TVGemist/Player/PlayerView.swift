//
//  PlayerView.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 07/12/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import AVFoundation

/// A simple `UIView` subclass that is backed by an `AVPlayerLayer` layer.
class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        //swiftlint:disable:next force_cast
        return layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
