//
//  LoadingIndicator.swift
//  WeathIt
//
//  Created by Niklas Korz on 20/10/17.
//  Copyright © 2017 Niklas Korz. All rights reserved.
//

import UIKit

class LoadingIndicator {
    
    static var counter = 0
    
    private static func update() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = counter > 0
    }
    
    static func increase() {
        counter += 1
        update()
    }
    
    static func decrease() {
        if counter == 0 {
            return
        }
        counter -= 1
        update()
    }
}
