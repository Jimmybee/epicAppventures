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

    struct CoreKeys {
        @nonobjc static var entityName = "AppventureStep"
    }
    
    convenience init (appventure: Appventure) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.setup = StepSetup(context: context)
        self.answerHint = [String]()
        self.answerText = [String]()
        self.appventure = appventure
        let coordinate = kCLLocationCoordinate2DInvalid
        self.coordinate2D = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    }
    
    convenience init(backendlessStep: BackendlessStep, persistent: Bool) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        
    }

    
    var locationSubtitle = "set location"
    var saveSound = false
    var saveImage = false
    
    var answerFormatHint = ""

}
