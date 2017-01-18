//
//  File.swift
//  EA - Clues
//
//  Created by James Birtwell on 17/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


extension Appventure {
    
    //MARK: Make Copy
    
    convenience init(appventure: Appventure, previousContext: NSManagedObjectContext?) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        
        //        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: previousContext)
        self.backendlessId = appventure.backendlessId
        self.title = appventure.title
        self.subtitle = appventure.subtitle
        self.pfFile = appventure.pfFile
        self.location = appventure.location
        self.totalDistance = appventure.totalDistance
        self.startingLocationName = appventure.startingLocationName
        self.duration = appventure.duration
        self.image = appventure.image
        self.keyFeatures = appventure.keyFeatures
        self.restrictions = appventure.restrictions
        self.liveStatus = appventure.liveStatus
        self.rating = appventure.rating
        
    }
    
    static func currentAppventureID() -> String? {
        return Appventure.currentAppventure?.backendlessId
    }
    
    /// saves appventure image to documents and under the filename of the managed objectId.
//    private func saveImageToDocuments() {
//        guard let image = self.image,
//            let rep = UIImageJPEGRepresentation(image, 1.0),
//            let data = NSData(data: rep) as? NSData else { return }
//        
//        imageFilename = String(describing: self.managedObjectContext)
//        
//        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        guard let path = dir?.appendingPathComponent(imageFilename!) else { return }
//        
//        let success = data.write(to: path, atomically: true)
//        
//        if !success {
//            print("failed local image save")
//        }
//        
//    }
    
    //    private func loadImageFromDocuments() -> UIImage? {
    //        guard let filename = imageFilename else { return nil }
    //        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    //        guard let path = dir?.appendingPathComponent(filename),
    //            let data = NSData(contentsOf: path),
    //            let image = UIImage(data: data as Data) else { return nil }
    //        return image
    //    }

    
}
