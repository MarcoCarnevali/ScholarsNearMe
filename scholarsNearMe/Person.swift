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
    let phoneNumber: String
    let uuid: String
    var image: UIImage?
    let whatsappFlag: Bool
    let smsFlag: Bool
    
    
    // Init with image as UIImage
    init(name: String, phoneNumber: String, uuid: String, whatsAppFlag: Bool, smsFlag: Bool, image: UIImage? = nil) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.uuid = uuid
        self.whatsappFlag = whatsAppFlag
        self.smsFlag = smsFlag
        self.image = image
    }
    
    // Init with image as NSData (for CoreData)
    convenience init(name: String, phoneNumber: String, uuid: String, whatsAppFlag: Bool, smsFlag: Bool, imageData: NSData? = nil) {
        var image : UIImage?
        
        if let imageData = imageData {
            image = UIImage(data: imageData)
        }
        
        self.init(name: name, phoneNumber: phoneNumber, uuid: uuid, whatsAppFlag: whatsAppFlag, smsFlag: smsFlag, image: image)
    }
}

// MARK: CoreData Utility Zone

extension Person {
    
    // Create an NSManagedObject from current Person Object. After the call of the methos a save() on managedContext Save the object in the permanent store
    func personToNSManagedObject(inManagedObjectContext objectContext: NSManagedObjectContext) -> NSManagedObject {
        let description = NSEntityDescription.entityForName("PersonEntity", inManagedObjectContext: objectContext)
        let managedObject = NSManagedObject(entity: description!, insertIntoManagedObjectContext: objectContext)
        
        managedObject.setValue(name, forKey: "name")
        managedObject.setValue(phoneNumber, forKey: "phoneNumber")
        managedObject.setValue(uuid, forKey: "uuid")
        managedObject.setValue(whatsappFlag, forKey: "whatsappFlag")
        managedObject.setValue(smsFlag, forKey: "smsFlag")
        
        if let image = self.image {
            let data = UIImagePNGRepresentation(image)
            managedObject.setValue(data, forKey: "image")
        }

        return managedObject
    }
    
    
    // Create a Person Object from the NSManagedObject that coreData search return 
    convenience init(managedObject: NSManagedObject) {
        let name = managedObject.valueForKey("name") as! String
        let phoneNumber = managedObject.valueForKey("phoneNumber") as! String
        let uuid = managedObject.valueForKey("uuid") as! String
        let whatsappFlag = managedObject.valueForKey("whatsappFlag") as! Bool
        let smsFlag = managedObject.valueForKey("smsFlag") as! Bool
        let imageData = managedObject.valueForKey("image") as? NSData
        
        self.init(name: name, phoneNumber: phoneNumber, uuid: uuid, whatsAppFlag: whatsappFlag, smsFlag: smsFlag, imageData: imageData)
    }
    
    
}