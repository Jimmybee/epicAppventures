//
//  CoreData.swift
//  EA - Clues
//
//  Created by James Birtwell on 06/11/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//


import UIKit
import CoreData

class CoreDataHelpers {
    
    static func fetchObjects(_ entityName: String, predicate: String = "") -> [NSManagedObject]? {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if predicate != "" {
            fetchRequest.predicate = NSPredicate(format: "id = %@", predicate)
        }
        
        do {
            if let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count == 0 {
                    return nil
                }
                return fetchResults
            }
        } catch {
            return nil
        }
        return nil
    }
    
    static func deleteAllData(_ entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
}
