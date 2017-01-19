//
//  Appventure+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

public class Appventure: NSManagedObject {
   
    var pfFile: AnyObject?
    
    static var currentAppventure: Appventure?
    var downloaded = true
    var liveStatus:LiveStatus {
            get { return LiveStatus(rawValue: self.liveStatusNum) ?? .inDevelopment }
            set { self.liveStatusNum = newValue.rawValue }
    }
    var appventureSteps: [AppventureStep] {
        get { return Array(steps) }
        set { print("setting steps") }
    }
    
    var appventureRating = AppventureRating()
    var saveImage = false
    
//    var distanceToSearch = 0.0
//    var tags: [String]?
    var rating = 5
    
    convenience init () {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.liveStatus = .inDevelopment
    }
    
    //MARK: CoreData
    
    struct CoreKeys {
        static let entityName = "Appventure"
    }
    
    //Save methods
    
    func downloadAndSaveToCoreData (_ handler: () -> ()) {
     //   AppventureStep.loadSteps(self, handler: handler)
    }
    
    func saveContext(handler: () -> ()) {
        if self.managedObjectContext  == nil {
            let context = AppDelegate.coreDataStack.persistentContainer.viewContext
            context.insert(self)
            self.owner = CoreUser.user!
        }
        
        AppDelegate.coreDataStack.saveContext()
        handler()
    }
    
    
    
    class func saveAllToCoreData(_ appventures: [Appventure]) {
        for appventure in appventures {
            appventure.downloadAndSaveToCoreData({
                
            })
        }
    }
    
    //delete from context
    
    func deleteAppventure() {
        self.deleteAppventureFromBackend()
        self.deleteFromContext({})
    }
    
    func deleteFromContext(_ handler: () -> ()) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        
        context.delete(self)
        do {
            try self.managedObjectContext?.save()
            handler()
        } catch let error as NSError  {
            print("Could not save to CD.. \(error), \(error.userInfo)")
        }
    }
    
    
}

enum LiveStatus: Int16 {
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

