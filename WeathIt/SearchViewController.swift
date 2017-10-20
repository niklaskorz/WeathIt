//
//  SearchViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        searchBar.delegate = self
        
        if let location = defaults.string(forKey: "location"), !location.isEmpty {
            performSegue(withIdentifier: "showWeather", sender: self)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            defaults.set(text, forKey: "location")
            performSegue(withIdentifier: "showWeather", sender: self)
        }
    }
    
}
