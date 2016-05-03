//
//  APIManager.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class APIManager {
        //() equals to Void
//    func loadData(urlString:String, completion: (result:String) -> ()) {
    func loadData(urlString:String, withHighQuality:Bool, completion: [Video] -> Void) {
        
        //Disable chache
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        
        let session = NSURLSession(configuration: config)
        
        //One session all over the app
//        let session = NSURLSession.sharedSession()
        let url = NSURL(string: urlString)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                //Added for JSONSerialization
                //print(data)
                
                do {
                    /* .AllowFragments - top level object is not Array or Dictionary.
                     Any type of string or value
                     NSJSONSerialization requires the Do / Try / Catch
                     Converts the NSData into a JSON object and cast it to a Dictionary */
                
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    as? JSONDictionary,
                        feed = json["feed"] as? JSONDictionary,
                        entries = feed["entry"] as? JSONArray {
                        
                        // Be careful not to put a lot of logic here in the APIManager
                        var videos = [Video]()
                        for (index, entry) in entries.enumerate() {
                            let entry = Video(data: entry as! JSONDictionary, quality:withHighQuality) // Custom initializer
                            entry.vRank = index + 1
                            videos.append(entry)
                        }
                        
                        let i = videos.count
                        print("iTunesApiManager - total count --> \(i)")
                        print(" ")
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                completion(videos)
                            }
                        }
                    }
                        
                } catch {
                    print("error in JSONSerialization")
                }
            
            }
        }
        task.resume()
    }
}