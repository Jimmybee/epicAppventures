//
//  AppventureStep+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData

public class AppventureStep: NSManagedObject {
    @nonobjc static var appventureStepsHc = "appventureStepsHc"
    
    struct setup {
        @nonobjc static var textClue = "textClue"
        @nonobjc static var pictureClue = "pictureClue"
        @nonobjc static var soundClue = "soundClue"
        @nonobjc static var checkIn = "checkIn"
        @nonobjc static var isLocation = "isLocation"
        @nonobjc static var locationShown = "locationShown"
        @nonobjc static var compassShown = "compassShown"
        @nonobjc static var distanceShown = "distanceShown"
    }
    
    
    struct CoreKeys {
        @nonobjc static var entityName = "AppventureStep"
    }
    
    convenience init (appventure: Appventure) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        let setup: [String:Bool] = [
            AppventureStep.setup.textClue : Bool(),
            AppventureStep.setup.pictureClue : Bool(),
            AppventureStep.setup.soundClue : Bool(),
            AppventureStep.setup.checkIn : Bool(),
            AppventureStep.setup.isLocation : Bool(),
            AppventureStep.setup.locationShown : Bool(),
            AppventureStep.setup.compassShown : Bool(),
            AppventureStep.setup.distanceShown : Bool(),
            ]
        
        self.setup = setup
        self.answerHint = [String]()
        self.answerText = [String]()
        self.appventure = appventure
        let coordinate = kCLLocationCoordinate2DInvalid
        self.coordinate2D = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    }
    
    var locationSubtitle = "set location"
    var saveSound = false
    var saveImage = false
    
    var answerFormatHint = ""

}
