//
//  DataModel.swift
//  scholarsNearMe
//
//  Created by Giacomo Leopizzi on 11/05/16.
//  Copyright © 2016 Eli Yazdi. All rights reserved.
//

import UIKit
import CoreData

class DataModel {
    
    static let sharedInstance = DataModel()
    
    private let coreDataStack = CoreDataStack()
    
    // Save changes to persistent storage
    func save() {
        coreDataStack.saveContext()
    }
    
    // Get a person by his UUID
    func getPersonByUUID(uuid: String, completionHandler: Person -> Void, nothingFoundHandler: (Void-> Void)? = nil) {
        fetchByUUID(uuid, completionHandler: { personObj in
            let person = Person(managedObject: personObj)
            completionHandler(person)
        }, nothingFoundHandler: nothingFoundHandler)
    }
    
    
    func savePerson(person: Person) {
        fetchByUUID(person.uuid, completionHandler: { managedObject in
            // An object with same UUID exist in Core Data. Just update values
            
            // Update managed Object values. Not update UUID...Not needed
            managedObject.setValue(person.name, forKey: "name")
            
            if let image = person.image {
                let data = UIImagePNGRepresentation(image)
                managedObject.setValue(data, forKey: "image")
            }
            
            // Save changes to CoreData
            self.save()
            }, nothingFoundHandler: {
            // The person not exit. Create object and save.
                
            person.personToNSManagedObject(inManagedObjectContext: self.coreDataStack.managedObjectContext)
            self.save()
                
        })
    }
    
    
    private func fetchByUUID(uuid: String, completionHandler: NSManagedObject -> Void, nothingFoundHandler: (Void-> Void)? = nil) {
        // Fetch a Person Entity
        let request = NSFetchRequest(entityName: "PersonEntity")
        
        // Fetch the person with same UUID
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            let result = try coreDataStack.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
            
            if let personObj = result.first {
                completionHandler(personObj)
            } else {
                nothingFoundHandler?()
            }
            
        } catch {
            return
        }
        
    }
}