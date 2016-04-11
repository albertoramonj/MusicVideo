//
//  ViewController.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    func didLoadData(result:String) {
        
        let alert = UIAlertController(title: result, message: nil, preferredStyle: .Alert)
     
        let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            //do something when user press ok
        }
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}

