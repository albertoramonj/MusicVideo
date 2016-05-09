//
//  AVPlayerViewController.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 9/5/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AVPlayerVC: AVPlayerViewController {
    var video:Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To avoid Warning: Attempt to present <MusicVideo.AVPlayerVC: 0x12d142800>  on <MusicVideo.MusicVideoTVC: 0x12c59aab0> which is already presenting (null)
        definesPresentationContext = true
        if (video != nil) {
            let url = NSURL(string: video!.vVideoUrl)!
            player = AVPlayer(URL: url)
            player?.play()
        }
    }
}
