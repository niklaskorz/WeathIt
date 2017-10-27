//
//  SearchViewController.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    let defaults = UserDefaults.standard
    let modelController = WeatherModelController.shared
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            navigationController?.popViewController(animated: true)
            modelController.loadWeather(location: text)
            modelController.loadForecast(location: text)
            defaults.set(text, forKey: "location")
        }
    }
}
