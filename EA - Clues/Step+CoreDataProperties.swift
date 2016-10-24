//
//  Step+CoreDataProperties.swift
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

extension AppventureStep {

    @NSManaged var answerHintObj: NSObject?
    @NSManaged var answerTextObj: NSObject?
    @NSManaged var appventurePFObjectID: String?
    @NSManaged var checkInProximity: Int16
    @NSManaged var completionText: String?
    @NSManaged var coordinateLat: Double
    @NSManaged var coordinateLon: Double
    @NSManaged var freeHints: Int16
    @NSManaged var hintPenalty: Int16
    @NSManaged var imageData: NSData?
    @NSManaged var initialText: String?
    @NSManaged var locationHidden: Bool
    @NSManaged var nameOrLocation: String?
    @NSManaged var pFObjectID: String?
    @NSManaged var setupObj: NSObject?
    @NSManaged var sound: NSData?
    @NSManaged var stepNumber: Int16
    @NSManaged var appventure: Appventure?

}
