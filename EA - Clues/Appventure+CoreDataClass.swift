//
//  Appventure+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData


public class Appventure: NSManagedObject {

    
    static fileprivate var currentAppventure: Appventure?
    
    //    var PFObjectID: String?
    //    var userID: String?
    //    var title: String? = ""
    //    var subtitle: String? = ""
    var coordinate: CLLocationCoordinate2D? = kCLLocationCoordinate2DInvalid
    //    var startingLocationName = ""
    //    var totalDistance:Double! = 0.0
    //    var duration = ""
    var image:UIImage?
    var imageFileName: String?
    var pfFile: AnyObject?
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
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        //        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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
    
    
    //Load methods
    
    class func loadAppventuresFromCoreData(_ handler: ([Appventure]) -> ()){
//        //        let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
//        let entityDescription = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
//        
//        // Configure Fetch Request
//        fetchRequest.entity = entityDescription
        
        var appventures = [Appventure]()
        
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext

        do {
            let fetchedAppventures = try context.fetch(Appventure.fetchRequest()) as! [Appventure]
            print("fetchedAppventures = \(fetchedAppventures.count)")
//            let result = try context.fetch(fetchRequest)
            handler(fetchedAppventures)

//            if let objects = result as? [NSManagedObject] {
//                print("fetchedCoreAppventures \(objects.count)")
//                for object in objects{
//                    let appventure = object as! Appventure
//                    print(appventure.steps?.count)
//                    appventure.appventureSteps.removeAll()
//                    
//                    if let set = appventure.steps {
//                        for stepObject in set {
//                            let step = stepObject as! AppventureStep
//                            step.setValuesForObject()
//                            appventure.appventureSteps.append(step)
//                        }
//                        print(" \(appventure.startingLocationName) \(appventure.appventureSteps.count)")                        }
//                    
//                    appventure.downloaded = true
//                    if let liveStatus = LiveStatus(rawValue: Int(appventure.liveStatusNum)) {
//                        appventure.liveStatus = liveStatus
//                    }
//                    // TODO: Get image from documents directory
////                    if let data = appventure.imageData {
////                        appventure.image = UIImage(data: data as Data)
////                    }
//                    appventures.append(appventure)
//                }
//            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
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
    
    
    func saveAndSync() {
        if self.managedObjectContext  == nil {
            let context = AppDelegate.coreDataStack.persistentContainer.viewContext
            context.insert(self)
        }
        self.completeSaveToContext({})
        //        self.saveToParse()
    }
    
    /// saves appventure image to documents and under the filename of the managed objectId.
    private func saveImageToDocuments() {
        guard let image = self.image,
            let rep = UIImageJPEGRepresentation(image, 1.0),
            let data = NSData(data: rep) as? NSData else { return }
        
        imageFileName = "picture1.jpg"
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let path = dir?.appendingPathComponent(imageFileName!) else { return }
        
        let success = data.write(to: path, atomically: true)
        
        if !success {
            // handle error
        }
        
    }
    
    func completeSaveToContext(_ handler: () -> ()) {
        
        self.liveStatusNum = Int16(self.liveStatus.rawValue)
        do {
            try self.managedObjectContext?.save()
            handler()
        } catch let error as NSError  {
            print("Could not save to CD.. \(error), \(error.userInfo)")
        }
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
        
        //        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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

