//
//  MyExtensions.swift
//  MusicVideo
//
//  Created by Alberto Ramon Janez on 18/4/16.
//  Copyright © 2016 arj. All rights reserved.
//

import UIKit

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
