//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 16/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    
    @IBOutlet weak var APICount: UILabel!
    @IBOutlet weak var sliderCount: UISlider!
    
    @IBAction func touchIDSec(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if touchID.on {
            defaults.setBool(touchID.on, forKey: "SecSetting")
        } else {
            defaults.setBool(false, forKey: "SecSetting")
        }
        //No need to sync
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #endif
        
        // Disables vertical bounce
        tableView.alwaysBounceVertical = false
        
        title = "Settings"
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
    }
    
    func preferredFontChanged() {
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        APICount.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }


}
