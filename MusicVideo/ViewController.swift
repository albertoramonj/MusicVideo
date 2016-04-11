//
//  ViewController.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videos = [Videos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json", completion: didLoadData)
        
        //Another way using closure
//        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json") {
//            (result:String) in
//            print(result)
//        }
        
    }
    
    //API callback
    func didLoadData(videos: [Videos]) {
        
        self.videos = videos
        
        for item in videos {
            print("name = \(item.vName)")
        }
        
        for (index, item) in videos.enumerate() {
            print("\(index) name = \(item.vName)")
        }
        
//        for i in 0..<videos.count {
//            let video = videos[i]
//            print("\(i) name = \(video.vName)")
//        }
        
    }
}

