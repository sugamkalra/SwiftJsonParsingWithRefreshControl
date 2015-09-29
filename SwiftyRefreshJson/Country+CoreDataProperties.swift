//
//  Country+CoreDataProperties.swift
//  SwiftyRefreshJson
//
//  Created by Sugam Kalra on 28/09/15.
//  Copyright © 2015 Sugam Kalra. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Country {

    @NSManaged var country: String?
    @NSManaged var detail: String?
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var id: String?
    @NSManaged var ipAddress: String?
    @NSManaged var lastName: String?

}
