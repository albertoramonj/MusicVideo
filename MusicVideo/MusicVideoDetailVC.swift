//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 15/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class MusicVideoDetailVC: UIViewController {

    var video:Videos!
    
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = video.vArtist
        vName.text = video.vName
        vPrice.text = video.vPrice
        vRights.text = video.vRights
        vGenre.text = video.vGenre
        
        if video.vImageData != nil {
            videoImage.image = UIImage(data:video.vImageData!)
        } else {
            //No image data available or doing background stuff yet
            videoImage.image = UIImage(named:"imageNotAvailable")
        }
    }

}
