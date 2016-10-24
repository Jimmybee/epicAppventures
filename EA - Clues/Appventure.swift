//
//  Appventure.swift
//  MapPlay
//
//  Created by James Birtwell on 09/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
import MapKit
import Parse
import CoreData

 class Appventure: NSManagedObject {
    
    static private var currentAppventure: Appventure?
    
//    var PFObjectID: String?
//    var userID: String?
//    var title: String? = ""
//    var subtitle: String? = ""
    var coordinate: CLLocationCoordinate2D? = kCLLocationCoordinate2DInvalid
//    var startingLocationName = ""
//    var totalDistance:Double! = 0.0
//    var duration = ""
    var image:UIImage?
    var pfFile: PFFile?
    var keyFeatures = [String]()
    var restrictions = [String]()
    var downloaded = false
    var liveStatus:LiveStatus = .inDevelopment
    
    
    
    //updates separately
    //    var interactivity = Filter.interactivityTypes.Static
    
    var appventureSteps = [AppventureStep]()
    var appventureRating = AppventureRating()
    
    //non-parse
    var saved = true
    var distanceToSearch = 0.0
    var tags: [String]?
    var rating = 2
    
    convenience init () {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName(CoreKeys.entityName, inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: nil)
    }
    
    static func currentAppventureID() -> String? {
        return Appventure.currentAppventure?.pFObjectID
    }
    
    static func setCurrentAppventure(appventure: Appventure) {
        Appventure.currentAppventure = appventure
    }
    
    //MARK: CoreData
    
    
    struct CoreKeys {
        static let entityName = "Appventure"
    }
    
    
    //Load methods
    
    class func loadAppventuresFromCoreData(handler: ([Appventure]) -> ()){
        let fetchRequest = NSFetchRequest()
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName(CoreKeys.entityName, inManagedObjectContext: managedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        var appventures = [Appventure]()
        
        do {
            let result = try managedContext.executeFetchRequest(fetchRequest)
            if let objects = result as? [NSManagedObject] {
                for object in objects{
                    let appventure = object as! Appventure
                    if let set = appventure.steps {
                        for stepObject in set {
                            let step = stepObject as! AppventureStep
                            step.setValuesForObject()
                            appventure.appventureSteps.append(step)
                        }
                    }
                    appventure.downloaded = true
                    if let data = appventure.imageData {
                        appventure.image = UIImage(data: data)
                    }
                    appventures.append(appventure)
                }
                handler(appventures)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    
    //Save methods
    
    func downloadAndSaveToCoreData (handler: () -> ()) {
        AppventureStep.loadSteps(self, handler: handler)
    }
    
    func saveToCoreData(handler: () -> ()) {
        //Add appventure to managed context
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        context.insertObject(self)
        
        //Add steps to managed context
        let stepSet = NSMutableOrderedSet()
        for step in self.appventureSteps {
            step.addToContext()
            let object = step as NSManagedObject
            stepSet.addObject(object)
        }
        
        self.steps = stepSet
        self.imageData = UIImagePNGRepresentation(self.image!)
        
        do {
            try self.managedObjectContext?.save()
            handler()
        } catch let error as NSError  {
            print("Could not save to CD.. \(error), \(error.userInfo)")
        }
    }
    
    class func saveAllToCoreData(appventures: [Appventure]) {
        for appventure in appventures {
            appventure.downloadAndSaveToCoreData(blank)
        }
    }
    
    class func blank() -> () {
    }
    
    //delete from context
    func deleteFromContext(handler: () -> ()) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        context.deleteObject(self)
        do {
            try self.managedObjectContext?.save()
            handler()
        } catch let error as NSError  {
            print("Could not save to CD.. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Make Copy
    
    convenience init(appventure: Appventure, previousContext: NSManagedObjectContext?) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName(CoreKeys.entityName, inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: previousContext)
        self.pFObjectID = appventure.pFObjectID
        self.title = appventure.title
        self.subtitle = appventure.subtitle
        self.pfFile = appventure.pfFile
        self.coordinate = appventure.coordinate
        self.totalDistance = appventure.totalDistance
        self.startingLocationName = appventure.startingLocationName
        self.duration = appventure.duration
        self.image = appventure.image
        self.keyFeatures = appventure.keyFeatures
        self.restrictions = appventure.restrictions
        self.liveStatus = appventure.liveStatus
        self.rating = appventure.rating
        
    }
    
    
    
    
}

enum LiveStatus: Int {
    case live = 0
    case waitingForApproval = 1
    case inDevelopment = 2
    case local = 3
    
    var label: String {
        switch self {
        case .live: return "Live"
        case .waitingForApproval: return "Awaiting Approval"
        case .inDevelopment: return "In Develoopment"
        case .local: return "Local"
        }
    }
    
    func segmentValue() -> Int {
        switch self {
        case .inDevelopment: return 0
        case .local: return 1
        case .waitingForApproval: return 2
        case .live: return 3
        }
    }
}
