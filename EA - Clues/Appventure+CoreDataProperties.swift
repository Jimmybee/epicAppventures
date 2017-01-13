//
//  Appventure+CoreDataProperties.swift
//  EA - Clues
//
//  Created by James Birtwell on 08/10/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Appventure {

    @NSManaged var coordinateLat: Double
    @NSManaged var coordinateLon: Double
    @NSManaged var duration: String?
    @NSManaged var imageData: Data?
    @NSManaged var keyFeaturesObj: NSObject?
    @NSManaged var liveStatusNum: Int16
    @NSManaged var pFObjectID: String?
    @NSManaged var restrictionsObj: NSObject?
    @NSManaged var startingLocationName: String?
    @NSManaged var subtitle: String?
    @NSManaged var title: String?
    @NSManaged var totalDistance: Double
    @NSManaged var userID: String?
    @NSManaged var steps: NSOrderedSet?

}
