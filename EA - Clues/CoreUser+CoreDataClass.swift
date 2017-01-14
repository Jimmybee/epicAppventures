//
//  CoreUser+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(CoreUser)
public class CoreUser: NSManagedObject {
    
    static var user: CoreUser?
    
    
    /// Check if cached user object exists. Otherwise load from context or create in context. 
    static func checkLogin(_ required: Bool, vc: UIViewController?) -> Bool {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        
        guard CoreUser.user == nil else { return true }
        let appventure = Appventure(context: context)
        let newUser = CoreUser(context: context)
        do {
            let fetchRequest: NSFetchRequest<CoreUser> = CoreUser.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if users.count == 0 {
                CoreUser.user = CoreUser(context: context)
                do {
                    try context.save()
                    return true
                } catch {
                    return false
                }
            } else {
                CoreUser.user = users[0]
                return true
            }
            //Check if backendless user account enabled.
            return true
        } catch {
            return false
        }

    }
    
}
