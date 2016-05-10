//
//  DataService.swift
//  Clocker 2.0
//
//  Created by Cristian Tabuyo on 9/4/16.
//  Copyright © 2016 Cristian Tabuyo. All rights reserved.
//

import Foundation

class DataService {
    
    static let ds = DataService()
    
    func setValue(value value: AnyObject, forKey: String) {
        NSUserDefaults.standardUserDefaults().setValue(value, forKey: forKey)
    }
    
    func valueForKey(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().valueForKey(key)
    }
    
    func setObject(value value : AnyObject, forKey: String) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: forKey)
    }
    
    
    
}