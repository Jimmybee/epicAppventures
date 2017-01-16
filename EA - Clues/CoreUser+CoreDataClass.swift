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

//@objc(CoreUser)
public class CoreUser: NSManagedObject {
    
    static var user: CoreUser?

    var userType: UserType {
        get { return UserType(rawValue: self.userTypeInt) ?? .noLogin }
        set { self.userTypeInt = newValue.rawValue }
    }
    
    var appventuresArray: [Appventure] {
        get {
            guard let appventures = ownedAppventures else { return [Appventure]() }
            return Array(appventures)
        }
    }
    
    /// Check if cached user object exists. Otherwise load from context or create in context.
    static func checkLogin(_ required: Bool = true, vc: UIViewController?) -> Bool {
        if CoreUser.user?.userType == .noLogin {
            return false
        } else {
            return true
        }
    }
    
    func loadFacebookPicture(completion: @escaping () -> ()) {
        
        guard let url = pictureUrl else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            if let getURL = URL(string: url) {
                if let data = try? Data(contentsOf: getURL){
                    self.facebookPicture = UIImage(data: data)
                    completion()
                }
            }
        }
    }
    
    
}

enum UserType: Int16 {
    case noUser = 0
    case noLogin
    case backendlessOnly
    case facebook
}
