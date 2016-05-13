//
//  Person.swift
//  scholarsNearMe
//
//  Created by Giacomo Leopizzi on 11/05/16.
//  Copyright © 2016 Eli Yazdi. All rights reserved.
//

import UIKit
import CoreData

class Person {
    
    let name: String
    let uuid: String
    var image: UIImage?
    
    
    // Init with image as UIImage
    init(name: String, uuid: String, image: UIImage? = nil) {
        self.name = name
        self.uuid = uuid
        self.image = image
    }
    
    // Init with image as NSData (for CoreData)
    convenience init(name: String, uuid: String, imageData: NSData? = nil) {
        var image : UIImage?
        
        if let imageData = imageData {
            image = UIImage(data: imageData)
        }
        
        self.init(name: name, uuid: uuid, imageData: UIImagePNGRepresentation(image!))
    }
}

// MARK: CoreData Utility Zone

extension Person {
    
    // Create an NSManagedObject from current Person Object. After the call of the methos a save() on managedContext Save the object in the permanent store
    func personToNSManagedObject(inManagedObjectContext objectContext: NSManagedObjectContext) -> NSManagedObject {
        let description = NSEntityDescription.entityForName("PersonEntity", inManagedObjectContext: objectContext)
        let managedObject = NSManagedObject(entity: description!, insertIntoManagedObjectContext: objectContext)
        
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(uuid, forKey: "uuid")
        
        if let image = self.image {
            let data = UIImagePNGRepresentation(image)
            managedObject.setValue(data, forKey: "image")
        }

        return managedObject
    }
    
    
    // Create a Person Object from the NSManagedObject that coreData search return 
    convenience init(managedObject: NSManagedObject) {
        let name = managedObject.valueForKey("name") as! String
        let uuid = managedObject.valueForKey("uuid") as! String
        let whatsappFlag = managedObject.valueForKey("whatsappFlag") as! Bool
        
        self.init(name: name, uuid: uuid, imageData: imageData)
    }
    
    
}