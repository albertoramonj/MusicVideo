//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 13/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

extension MusicVideoTVC: SettingsTVCDelegate {
    func sliderCountChanged(count: Int, sender: SettingsTVC) {
        runAPI()
    }
}

class MusicVideoTVC: UITableViewController {
    
    var videos = [Videos]()
    
    var limit = 10
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        runAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #endif
        
        reachabilityStatusChanged()
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        title = "The iTunes Top \(limit) Music Videos"
        
        tableView.reloadData()
        
    }
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS:
            //view.backgroundColor = UIColor.redColor()
            // move back to the main Queue to avoid "Presenting view controllers on detached view controllers is discouraged" warning
            dispatch_async(dispatch_get_main_queue()) {
                let alert = UIAlertController(title: "No Internet Access", message: "Please make sure you are connected to the Internet", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {
                    action -> () in
                    print("Cancel")
                }
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) {
                    action -> () in
                    print("Delete")
                }
                
                let okAction = UIAlertAction(title: "Ok", style: .Default) {
                    action -> () in
                    print("Ok")
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        default:
            //view.backgroundColor = UIColor.greenColor()
            if videos.count > 0 {
                print("do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    func preferredFontChanged() {
        print("The preferred font has changed")
    }
    
    func getAPICount() {
        if let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICount") as? Int {
            limit = theValue
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDate = formatter.stringFromDate(NSDate())
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")
    }
    
    func runAPI() {
        getAPICount()
        
        //Call API
        let api = APIManager()
        
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
    }
    
    // Is called just as the object is about to be deallocated
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }

    private struct storyboard {
        static let cellReuseIdentifier = "cell"
        static let segueToDetailIdentifier = "musicDetail"
        static let segueToSettingsIdentifier = "settings"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        cell.video = videos[indexPath.row]
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueToDetailIdentifier {
            if let indexpath = tableView.indexPathForSelectedRow {
                let video = videos[indexpath.row]
                let dvc = segue.destinationViewController as! MusicVideoDetailVC
                dvc.video = video 
                
            }
        }
        
        if segue.identifier == storyboard.segueToSettingsIdentifier {
            let settingsTVC = segue.destinationViewController as! SettingsTVC
            settingsTVC.delegate = self
        }
    }
    

}
