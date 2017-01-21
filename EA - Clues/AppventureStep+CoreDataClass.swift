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
    
    /// init for creating a step
    convenience init (appventure: Appventure) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.setup = StepSetup(step: self, context: context)
        self.answerHint = [String]()
        self.answerText = [String]()
        self.appventure = appventure
        let coordinate = kCLLocationCoordinate2DInvalid
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    }
    
    /// init for creating a step from backendless API
    convenience init(backendlessStep: BackendlessStep, persistent: Bool) {
        let context = persistent ? AppDelegate.coreDataStack.persistentContainer.viewContext : AppDelegate.coreDataStack.tempContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.backendlessId = backendlessStep.objectId
        self.nameOrLocation = backendlessStep.nameOrLocation
        self.stepNumber = backendlessStep.stepNumber ?? 0
    }
    
    
    var locationSubtitle = "set location"
    var saveSound = false
    var saveImage = false
    
    var answerFormatHint = ""

}
