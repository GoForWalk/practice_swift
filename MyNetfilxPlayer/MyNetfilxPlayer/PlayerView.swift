//
//  PlayerView.swift
//  MyNetfilxPlayer
//
//  Created by sae hun chung on 2022/01/05.
//

// https://developer.apple.com/documentation/avfoundation/avplayerlayer

import UIKit
import AVFoundation

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        } set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
