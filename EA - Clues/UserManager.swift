//
//  UserManager.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


class UserManager {
    
    static var backendless = Backendless.sharedInstance()
    
    struct backendlessFields {
        static let facebookId = "facebookId"
        static let name = "name"
        static let pictureUrl = "pictureURL"
    }
    
    static let fieldsMapping = [
        "id" : backendlessFields.facebookId,
        "name" : backendlessFields.name,
        "birthday": "birthday",
        "first_name": "fb_first_name",
        "last_name" : "fb_last_name",
        "gender": "gender",
        "email": "email",
//        "pictureURL": backendlessFields.pictureUrl
        
    ]
    
    static func setupUser() {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<CoreUser> = CoreUser.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if users.count == 0 {
                CoreUser.user = CoreUser(context: context)
                AppDelegate.coreDataStack.saveContext()
            } else {
                CoreUser.user = users[0]
            }
        } catch {
            fatalError("Unresolved error")
        }
        
        let backendless = Backendless.sharedInstance()
        if backendless?.userService.currentUser == nil {
            CoreUser.user?.userType = .noLogin
            return
        }
        
        mapBackendlessToCoreUser()
        
        if CoreUser.user?.facebookId == nil {
            CoreUser.user?.userType = .backendlessOnly
            return
        }
        
        CoreUser.user?.userType = .facebook
    }
    
    static func mapBackendlessToCoreUser() {
        let user = backendless!.userService.currentUser
        CoreUser.user?.name = user?.getProperty(backendlessFields.name) as? String
        CoreUser.user?.facebookId = user?.getProperty(backendlessFields.facebookId) as? String
//        CoreUser.user?.pictureUrl = user?.getProperty(backendlessFields.pictureUrl) as? String
    }
    
    
    
    static func loginWithFacebook() {
        backendless!.userService.easyLogin(withFacebookFieldsMapping: UserManager.fieldsMapping, permissions:  ["public_profile", "email", "user_friends"], response: { (result) in
            print("Result: \(result)")
            centralDispatchGroup.leave()
            
        }, error: { (fault) in
            centralDispatchGroup.leave()
            print("Server reported an error: \(fault)")
            
        })
    }
    
}
