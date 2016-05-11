//
//  PersonEntity+CoreDataProperties.swift
//  scholarsNearMe
//
//  Created by Giacomo Leopizzi on 11/05/16.
//  Copyright © 2016 Eli Yazdi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PersonEntity {

    @NSManaged var name: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var uuid: String?
    @NSManaged var image: NSData?
    @NSManaged var whatsappFlag: NSNumber?
    @NSManaged var smsFlag: NSNumber?

}
