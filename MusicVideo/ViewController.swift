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
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        #endif
        
        reachabilityStatusChanged()
        
        
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
        
        print(reachabilityStatus)
        
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
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS: view.backgroundColor = UIColor.redColor()
        displayLabel.text = "No internet"
        case WIFI: view.backgroundColor = UIColor.greenColor()
        displayLabel.text = "Reachable with WIFI"
        case NOACCESS: view.backgroundColor = UIColor.yellowColor()
        displayLabel.text = "Reachable with Cellular"
        default:
            return
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
}

