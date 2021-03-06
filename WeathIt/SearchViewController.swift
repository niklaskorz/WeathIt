//
//  SearchViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

// Controller for the location search scene
class SearchViewController: UIViewController, UISearchBarDelegate {
    let defaults = UserDefaults.standard
    let modelController = WeatherModelController.shared
    
    override func viewDidLoad() {
        let firstStart = SettingsController.shared.location == nil
        navigationItem.hidesBackButton = firstStart
        if firstStart {
            log.info("Welcome!")
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            navigationController?.popViewController(animated: true)
            SettingsController.shared.location = text
        }
    }
}
