//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Video {
    
    // Data Encapsulation
    
    // set will do the getters automatically
    private(set) var vRank:Int
    private(set) var vName:String // non optional (?) because we're going to initilize it later
    private(set) var vRights:String
    private(set) var vPrice:String
    private(set) var vImageUrl:String
    private(set) var vArtist:String
    private(set) var vVideoUrl:String
    private(set) var vImid:String
    private(set) var vGenre:String
    private(set) var vLinkToiTunes:String
    private(set) var vReleaseDte:String
    
    // This variable gets created from the UI
    var vImageData:NSData?
    

    // Better this way: single responsibility principle
    init(vRank:Int, vName:String, vRights:String, vPrice:String,
         vImageUrl:String, vArtist:String, vVideoUrl:String, vImid:String,
         vGenre:String, vLinkToiTunes:String, vReleaseDte:String) {
        
        self.vRank = vRank
        self.vName = vName
        self.vRights = vRights
        self.vPrice = vPrice
        self.vImageUrl = vImageUrl
        self.vArtist = vArtist
        self.vVideoUrl = vVideoUrl
        self.vImid = vImid
        self.vGenre = vGenre
        self.vLinkToiTunes = vLinkToiTunes
        self.vReleaseDte = vReleaseDte
        
    }
    
//    init(data: JSONDictionary, quality:Bool) {
//        self.vName = ""
//        self.vRights = ""
//        self.vPrice = ""
//        self.vImageUrl = ""
//        self.vArtist = ""
//        self.vVideoUrl = ""
//        self.vImid = ""
//        self.vGenre = ""
//        self.vLinkToiTunes = ""
//        self.vReleaseDte = ""
//        
//        //Video name
//        if let imName = data["im:name"] as? JSONDictionary,
//            label = imName["label"] as? String {
//                vName = label
//        }
//        
//        //Video Studio Name
//        if let rightsDict = data["rights"] as? JSONDictionary,
//            label = rightsDict["label"] as? String {
//                vRights = label
//        }
//        
//        //Video price
//        if let imPrice = data["im:price"] as? JSONDictionary,
//            label = imPrice["label"] as? String {
//                vPrice = label
//        }
//        
//        //Video image
//        if let imImage = data["im:image"] as? JSONArray,
//            image = imImage[2] as? JSONDictionary,
//            label = image["label"] as? String {
//            if quality {
//                vImageUrl = label.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
//            } else {
//                vImageUrl = label
//            }
//        }
//        
//        //Video artist
//        if let imArtist = data["im:artist"] as? JSONDictionary,
//            label = imArtist["label"] as? String {
//                vArtist = label
//        }
//        
//        //Video url
//        if let link = data["link"] as? JSONArray,
//            vUrl = link[1] as? JSONDictionary,
//            attributes = vUrl["attributes"] as? JSONDictionary,
//            href = attributes["href"] as? String {
//                vVideoUrl = href
//        }
//        
//        //Artist id
//        if let id = data["id"] as? JSONDictionary,
//            attributes = id["attributes"] as? JSONDictionary,
//            imId = attributes["im:id"] as? String {
//                vImid = imId
//        }
//        
//        //Video genre
//        if let category = data["category"] as? JSONDictionary,
//            attributes = category["attributes"] as? JSONDictionary,
//            term = attributes["term"] as? String {
//                vGenre = term
//        }
//        
//        //Video link to iTunes
//        if let id = data["id"] as? JSONDictionary,
//            label = id["label"] as? String {
//                vLinkToiTunes = label
//        }
//        
//        //Video release date
//        if let imReleaseDate = data["im:releaseDate"] as? JSONDictionary,
//            attributes = imReleaseDate["attributes"] as? JSONDictionary,
//            label = attributes["label"] as? String {
//                vReleaseDte = label
//        }
//  }
    
}