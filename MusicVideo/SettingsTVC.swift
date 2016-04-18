//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 16/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit
import MessageUI
import LocalAuthentication

protocol SettingsTVCDelegate: class {
    func sliderCountChanged(count: Int, sender: UISlider)
    func bestImageSwitchChanged(sender: UISwitch)
}

class SettingsTVC: UITableViewController, MFMailComposeViewControllerDelegate {

    weak var delegate:SettingsTVCDelegate?
    
    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var bestImage: UISwitch!
    @IBOutlet weak var numberOfVideosDisplay: UILabel!
    @IBOutlet weak var dragTheSliderDisplay: UILabel!
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
    
    @IBAction func bestImageChanged(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(sender.on, forKey: "bestImageSetting")
        delegate?.bestImageSwitchChanged(sender)
    }
    
    @IBAction func valueChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sliderCount.value), forKey: "APICount")
        APICount.text = "\(Int(sliderCount.value))"
    }
    
    @IBAction func valueChangesEnded(sender: UISlider) {
        delegate?.sliderCountChanged(Int(sliderCount.value), sender: sender)
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
        touchID.enabled = isThePhoneTouchIdCapable()
        bestImage.on = NSUserDefaults.standardUserDefaults().boolForKey("bestImageSetting")
        
        
        //Always check if it's not nil
        if let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICount") as? Int {
            APICount.text = "\(theValue)"
            sliderCount.value = Float(theValue)
        } else {
            sliderCount.value = 10.0
            APICount.text = "\(sliderCount.value)"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            let mailComposeViewController = configureMail()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                // No email account setup on phone
                mailAlert()
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func configureMail() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["test@test.com"])
        mailComposeVC.setSubject("Music Video App Feedback")
        mailComposeVC.setMessageBody("Hi Alberto,\n\nI would like to share the following feedback...\n", isHTML: false)
        return mailComposeVC
    }
    
    func mailAlert() {
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: "No email account setup for phone", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            //do something if you want
        }
        alertController.addAction(okAction)
        self .presentViewController(alertController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail Failed")
        default:
            print("Unknown Issue")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isThePhoneTouchIdCapable() -> Bool {
        // Create the Local Authentication Context
        let context = LAContext()
        var touchIDError : NSError?
        
        // Check if we can access local device authentication
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error:&touchIDError) {
            return true
        } else {
            securityDisplay.text = "Security not available"
            return false
        }
    }
    
    func preferredFontChanged() {
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        APICount.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        numberOfVideosDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        dragTheSliderDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }


}
