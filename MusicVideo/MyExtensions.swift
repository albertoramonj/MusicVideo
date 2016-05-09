//
//  MyExtensions.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 18/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

extension MusicVideoTVC: SettingsTVCDelegate {
    func sliderCountChanged(count: Int, sender: UISlider) {
        runAPI()
    }
    
    func bestImageSwitchChanged(sender: UISwitch) {
        runAPI()
    }
}

extension MusicVideoTVC: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        filterSearch(searchController.searchBar.text!.lowercaseString)
    }
}

extension MusicVideoTVC: UIViewControllerPreviewingDelegate {
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView?.indexPathForRowAtPoint(location) else { return nil }
        
        guard let cell = tableView?.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let detailVC = storyboard?.instantiateViewControllerWithIdentifier("AVPlayerVC") as? AVPlayerVC else { return nil }
        
        let video: Video
        video = resultSearchController.active ? filteredSearch[indexPath.row] : videos[indexPath.row]
        detailVC.video = video
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
}
