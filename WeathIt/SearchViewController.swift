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
    
    override func viewDidLoad() {
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "showWeather", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showWeather" else {
            return
        }
        let viewController = segue.destination as! WeatherViewController
        viewController.loadWeather(location: searchBar.text!)
        viewController.loadForecast(location: searchBar.text!)
    }
    
}
