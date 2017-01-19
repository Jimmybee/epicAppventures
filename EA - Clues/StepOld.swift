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
    @NSManaged var imageData: Data?
    @NSManaged var initialText: String?
    @NSManaged var locationHidden: Bool
    @NSManaged var nameOrLocation: String?
    @NSManaged var pFObjectID: String?
    @NSManaged var setupObj: NSObject?
    @NSManaged var sound: Data?
    @NSManaged var stepNumber: Int16
    @NSManaged var appventure: Appventure?

}

//@NSManaged public var answerHint: [String]!
//@NSManaged public var answerText: [String]!
//@NSManaged public var appventurePFObjectID: String?
//@NSManaged public var checkInProximity: Int16
//@NSManaged public var completionText: String?
//@NSManaged public var freeHints: Int16
//@NSManaged public var hintPenalty: Int16
//@NSManaged public var image: UIImage?
//@NSManaged public var initialText: String?
//@NSManaged public var locationHidden: Bool
//@NSManaged public var nameOrLocation: String?
//@NSManaged public var backendlessId: String?
//@NSManaged public var setup: [String : Bool]!
//@NSManaged public var sound: Data?
//@NSManaged public var stepNumber: Int16
//@NSManaged public var coordinate2D: CLLocation?
//@NSManaged public var appventure: Appventure?
//@NSManaged public var stepSetup: StepSetup?
