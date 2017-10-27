//
//  SettingsController.swift
//  WeathIt
//
//  Created by Niklas Korz on 27/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

protocol SettingsControllerDelegate {
    func locationDidChange(location: String?)
    func refreshIntervalDidChange(refreshInterval: RefreshInterval)
}

class SettingsController {
    static let shared = SettingsController()
    let defaults = UserDefaults.standard
    var delegate: SettingsControllerDelegate?
    
    var location: String? {
        set {
            if let value = newValue {
                defaults.set(value, forKey: "location")
            } else {
                defaults.removeObject(forKey: "location")
            }
        }
        get {
            return defaults.string(forKey: "location")
        }
    }
    
    private let defaultRefreshInterval = RefreshInterval.perMinute(30)
    var refreshInterval: RefreshInterval {
        set {
            defaults.set(newValue.serialize(), forKey: "refreshInterval")
        }
        get {
            if let serializedInterval = defaults.object(forKey: "refreshInterval") as? UInt,
                let interval = RefreshInterval.parse(serialized: serializedInterval) {
                return interval
            }
            return defaultRefreshInterval
        }
    }
    
    init() {}
}
