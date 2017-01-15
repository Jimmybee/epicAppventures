//
//  Appventure+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit
import CoreData


public class Appventure: NSManagedObject {

    
    static fileprivate var currentAppventure: Appventure?
    
    var coordinate: CLLocationCoordinate2D? = kCLLocationCoordinate2DInvalid
    var imageAccess: UIImage? {
        get {
            if image != nil {
                return image
            } else {
                self.image = self.loadImageFromDocuments()
                return image
            }
        }
    }
    var image: UIImage?
    var pfFile: AnyObject?

    var downloaded = false
    var liveStatus:LiveStatus = .inDevelopment
    
    
    var appventureSteps = [AppventureStep]()
    var appventureRating = AppventureRating()
    
    //non-parse
    var saved = true
    var distanceToSearch = 0.0
    var tags: [String]?
    var rating = 2
    
    convenience init () {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: nil)
    }
    
    static func currentAppventureID() -> String? {
        return Appventure.currentAppventure?.pFObjectID
    }
    
    static func setCurrentAppventure(_ appventure: Appventure) {
        Appventure.currentAppventure = appventure
    }
    
    //MARK: CoreData
    
    struct CoreKeys {
        static let entityName = "Appventure"
    }
    
    //Save methods
    
    func downloadAndSaveToCoreData (_ handler: () -> ()) {
        AppventureStep.loadSteps(self, handler: handler)
    }
    
    func saveToCoreData(_ handler: () -> ()) {
        //        print("Appventure: \(self.title)")
        //Add appventure to managed context
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        //        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        context.insert(self)
        
        //Add steps to managed context
        let stepSet = NSMutableOrderedSet()
        for step in self.appventureSteps {
            step.addToContext()
            let object = step as NSManagedObject
            stepSet.add(object)
        }
        
//        self.steps = stepSet
        //        print("setSteps :\(self.steps?.count)")
        
        
//        if let imageFile = self.pfFile as AnyObject! {
            //            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
            //                if error == nil {
            //                    if let dataFound = data {
            //                        self.image = UIImage(data: dataFound)
            //                        self.completeSaveToContext(handler)
            //                    }
            //                }
            //            })
//        }
        
    }
    
    
    func saveContext(handler: () -> ()) {
        if self.managedObjectContext  == nil {
            let context = AppDelegate.coreDataStack.persistentContainer.viewContext
            context.insert(self)
            self.owner = CoreUser.user!
        }
        
        saveImageToDocuments()
        
        do {
            try self.managedObjectContext?.save()
            handler()
        } catch let error as NSError  {
            print("Could not save to CD.. \(error), \(error.userInfo)")
        }
    }
    
    /// saves appventure image to documents and under the filename of the managed objectId.
    private func saveImageToDocuments() {
        guard let image = self.image,
            let rep = UIImageJPEGRepresentation(image, 1.0),
            let data = NSData(data: rep) as? NSData else { return }
        
        imageFilename = String(describing: self.managedObjectContext)
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let path = dir?.appendingPathComponent(imageFilename!) else { return }
        
        let success = data.write(to: path, atomically: true)
        
        if !success {
            print("failed local image save")
        }
        
    }
    
    private func loadImageFromDocuments() -> UIImage? {
        guard let filename = imageFilename else { return nil }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let path = dir?.appendingPathComponent(filename),
            let data = NSData(contentsOf: path),
            let image = UIImage(data: data as Data) else { return nil }
        return image
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
    
    //MARK: Make Copy
    
    convenience init(appventure: Appventure, previousContext: NSManagedObjectContext?) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        
        //        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: previousContext)
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

