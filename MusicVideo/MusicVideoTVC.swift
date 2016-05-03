//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 13/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

class MusicVideoTVC: UITableViewController {
    
    var videos = [Video]()
    
    var filteredSearch = [Video]()
    
    // nil because we want to show the results on the same view
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    var limit = 10
    
    //True if both wifi and settings switch are enabled. False otherwise
    var bestImageQuality: Bool = false
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        
        if (resultSearchController.active) {
            refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        } else {
            runAPI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(preferredFontChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChanged", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        #endif
        
        reachabilityStatusChanged()
    }
    
    //API callback
    func didLoadData(videos: [Video]) {
        
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
        
        resultSearchController.searchResultsUpdater = self
        //prevents the search bar to show if the user navigate to other view
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist, name, Rank"
        resultSearchController.searchBar.searchBarStyle = .Prominent
        
        //add the search bar to your tableview
        tableView.tableHeaderView = resultSearchController.searchBar
        
        
        
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

            //if imageQuality it's the same than settings and we're on wifi
            if videos.count > 0 && reachabilityStatus == WIFI && bestImageQuality == NSUserDefaults.standardUserDefaults().boolForKey("bestImageSetting") {
                print("do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    func setImageQuality() {
        bestImageQuality = false
        if (NSUserDefaults.standardUserDefaults().boolForKey("bestImageSetting") && reachabilityStatus == WIFI) {
            bestImageQuality = true
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
        setImageQuality()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", withHighQuality:bestImageQuality, completion: didLoadData)
    }
    
    func filterSearch(searchText: String) {
        filteredSearch = videos.filter {$0.vArtist.lowercaseString.containsString(searchText) || $0.vName.lowercaseString.containsString(searchText) || $0.vRank == Int(searchText)}
        
        //Another way
//        filteredSearch = videos.filter { videos in
//            return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString) || videos.vName.lowercaseString.containsString(searchText.lowercaseString) || "\(videos.vRank)".lowercaseString.containsString(searchText.lowercaseString)
//        }
        
        tableView.reloadData()
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
        if resultSearchController.active {
            return filteredSearch.count
        }
        return videos.count
    }

    private struct storyboard {
        static let cellReuseIdentifier = "cell"
        static let segueToDetailIdentifier = "musicDetail"
        static let segueToSettingsIdentifier = "settings"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! MusicVideoTableViewCell
        
        if resultSearchController.active {
            cell.video = filteredSearch[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]
        }
        
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
                let video: Video
                if resultSearchController.active {
                    video = filteredSearch[indexpath.row]
                } else {
                    video = videos[indexpath.row]
                }
                
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


