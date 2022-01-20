//
//  PlayerViewController.swift
//  MyNetfilxPlayer
//
//  Created by sae hun chung on 2022/01/05.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var playButton: UIButton!
    
    let player = AVPlayer()
    
    // modal landscape mode로 display
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    
    override func viewDidLoad() { // viewController 가 메모리에 올라옴.
        super.viewDidLoad()
        playerView.player = player
    }
    
    // play button click 시 toggle
    @IBAction func togglePlayButton(_ sender: Any) {
        if player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        reset()
        dismiss(animated: false, completion: nil)
    }
    
    func pause(){
        player.pause()
        playButton.isSelected = false
    }
    
    func play(){
        player.play()
        playButton.isSelected = true
    }
    
    func reset() {
        pause()
        player.replaceCurrentItem(with: nil)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else {return false}
        return self.rate != 0
    }
}
