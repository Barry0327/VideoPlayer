//
//  PlayerView.swift
//  VideoPlayer
//
//  Created by Chen Yi-Wei on 2019/5/7.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//
import AVKit
import Foundation

class PlayerView: UIView {

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    // swiftlint:disable all
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
