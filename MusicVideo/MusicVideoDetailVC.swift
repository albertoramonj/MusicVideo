//
//  MusicVideoDetailVC.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 15/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import LocalAuthentication

class MusicVideoDetailVC: UIViewController {

    var video:Video!
    
    var securitySwitch: Bool = false
    
//    var sec:Bool = false
    
    @IBOutlet weak var vName: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var vGenre: UILabel!
    @IBOutlet weak var vPrice: UILabel!
    @IBOutlet weak var vRights: UILabel!
    @IBOutlet weak var vRatingControl: RatingControl!
    
    @IBAction func playVideo(sender: UIBarButtonItem) {
        let url = NSURL(string: video.vVideoUrl)!
        let player = AVPlayer(URL: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    @IBAction func socialMedia(sender: UIBarButtonItem) {
        securitySwitch = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        switch securitySwitch {
        case true:
            touchIDCheck()
        default:
            shareMedia()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #endif
        
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
    
    func touchIDCheck() {
        TouchIdHelper.userAuthenticate { (success, alert) in
            if success {
                // User authenticated using Local Device Authentication Successfully!
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.shareMedia()
                }
            } else {
                // Show the alert
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func shareMedia() {
        let activity1 = "Have you had the opportunity to see this Music Video?"
        let activity2 = "\(video.vName) by \(video.vArtist)"
        let activity3 = "Watch it and tell me waht you think?"
        let activity4 = video.vLinkToiTunes
        let activity5 = "Shared with the Music Video App - Step It UP!"
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activity1, activity2, activity3, activity4, activity5], applicationActivities: nil)
        
//        activityViewController.excludedActivityTypes = [UIActivityTypeMail]
        
        //        activityViewController.excludedActivityTypes =  [
        //            UIActivityTypePostToTwitter,
        //            UIActivityTypePostToFacebook,
        //            UIActivityTypePostToWeibo,
        //            UIActivityTypeMessage,
        //            UIActivityTypeMail,
        //            UIActivityTypePrint,
        //            UIActivityTypeCopyToPasteboard,
        //            UIActivityTypeAssignToContact,
        //            UIActivityTypeSaveToCameraRoll,
        //            UIActivityTypeAddToReadingList,
        //            UIActivityTypePostToFlickr,
        //            UIActivityTypePostToVimeo,
        //            UIActivityTypePostToTencentWeibo
        //        ]

        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if activity == UIActivityTypeMail {
                print("email selected")
            }
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }

    func preferredFontChanged() {
        vName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vPrice.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vRights.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        vGenre.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "preferredFontChanged", object: nil)
    }
}
