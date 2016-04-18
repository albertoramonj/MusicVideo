//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 11/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import Foundation

class Videos {
    
    var vRank = 0
    
    // Data Encapsulation
    
    private(set) var _vName:String // non optional (?) because we're going to initilize it later
    private(set) var _vRights:String
    private(set) var _vPrice:String
    private(set) var _vImageUrl:String
    private(set) var _vArtist:String
    private(set) var _vVideoUrl:String
    private(set) var _vImid:String
    private(set) var _vGenre:String
    private(set) var _vLinkToiTunes:String
    private(set) var _vReleaseDte:String
    
    // This variable gets created from the UI
    var vImageData:NSData?
    
    //Make a getter
    
    var vName: String {
        return _vName
    }
    
    var vRights: String {
        return _vRights
    }
    
    var vPrice: String {
        return _vPrice
    }
    
    var vImageUrl: String {
        return _vImageUrl
    }
    
    var vArtist: String {
        return _vArtist
    }
    
    var vVideoUrl: String {
        return _vVideoUrl
    }
    
    var vImid: String {
        return _vImid
    }
    
    var vGenre: String {
        return _vGenre
    }
    
    var vLinkToiTunes: String {
        return _vLinkToiTunes
    }
    
    var vReleaseDte: String {
        return _vReleaseDte
    }
    
    init(data: JSONDictionary, quality:Bool) {
        
        //If we do not initialize all properties we will get error message
        //Return from initializer without initializing all stored properties
        
        //Video name
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
            self._vName = vName
        } else {
            //You may not always get data back from the JSON - you may want to display message
            // element in the JSON unexpected
            
            _vName = ""
        }
        
        //Video Studio Name
        if let rights = data["rights"] as? JSONDictionary,
            vRights = rights["label"] as? String {
            self._vRights = vRights
        } else {
            _vRights = ""
        }
        
        //Video price
        if let price = data["im:price"] as? JSONDictionary,
            vPrice = price["label"] as? String {
            self._vPrice = vPrice
        } else {
            _vPrice = ""
        }
        
        //Video image
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
            if quality {
                self._vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
            } else {
                self._vImageUrl = immage
            }
        } else {
            _vImageUrl = ""
        }
        
        //Video artist
        if let artist = data["im:artist"] as? JSONDictionary,
            vArtist = artist["label"] as? String {
            self._vArtist = vArtist
        } else {
            _vArtist = ""
        }
        
        //Video url
        if let video = data["link"] as? JSONArray,
            vUrl = video[1] as? JSONDictionary,
            vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
            self._vVideoUrl = vVideoUrl
        } else {
            _vVideoUrl = ""
        }
        
        //Artist id
        if let imid = data["id"] as? JSONDictionary,
            vid = imid["attributes"] as? JSONDictionary,
            vImid = vid["im:id"] as? String {
            self._vImid = vImid
        } else {
            _vImid = ""
        }
        
        //Video genre
        if let genre = data["category"] as? JSONDictionary,
            vGenre = genre["attributes"] as? JSONDictionary,
            vTerm = vGenre["term"] as? String {
            self._vGenre = vTerm
        } else {
            _vGenre = ""
        }
        
        //Video link to iTunes
        if let link = data["id"] as? JSONDictionary,
            vLink = link["label"] as? String {
            self._vLinkToiTunes = vLink
        } else {
            _vLinkToiTunes = ""
        }
        
        //Video release date
        if let date = data["im:releaseDate"] as? JSONDictionary,
            vAttributes = date["attributes"] as? JSONDictionary,
            vDate = vAttributes["label"] as? String {
            self._vReleaseDte = vDate
        } else {
            _vReleaseDte = ""
        }
    }
}