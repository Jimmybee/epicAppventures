//
//  FriendsAdventures.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation
import Parse

protocol FriendsAdventuresDelegate: NSObjectProtocol {
    func shareComplete(succes: Bool)
}

class FriendsAdventures: NSObject {
    
    struct parseCol {
//        static let ownerID = "OwnerID"
        static let pfClass = "FriendsAdventures"
        static let fbUserID = "fbUserID"
        static let appventureFKID = "appventureFKID"
    }
    
    
    
    static func saveObject(appventureID: String, fbUserID: String, delegate: FriendsAdventuresDelegate) {
        let save = PFObject(className: parseCol.pfClass)

        save[parseCol.fbUserID] = fbUserID
        save[parseCol.appventureFKID] = appventureID
        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                delegate.shareComplete(false)
            } else {
                delegate.shareComplete(true)
            }
        }
    }

    
    static func fetchFriendAdventures(handler: ([Appventure]) -> Void) {
        var friendsAdventures = [Appventure]()
        if let user = User.user {
            let query = PFQuery(className:parseCol.pfClass)
            print("facebookid: \(user.facebookId)")
            query.whereKey(parseCol.fbUserID, equalTo: user.facebookId)
            query.limit = 100
            var friendAdventures = [String]()
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object in objects! {
                        let appventureID = object.objectForKey(parseCol.appventureFKID) as! String
                        friendAdventures.append(appventureID)
                    }
                    let uniqueAdventureIDs = Array(Set(friendAdventures))

                    for adventureID in uniqueAdventureIDs {
                        let query = PFQuery(className: Appventure.pfAppventure.pfClass)
                        query.getObjectInBackgroundWithId(adventureID) {
                            (object: PFObject?, error: NSError?) -> Void in
                            if error != nil {
                                print("Get parse object error: /(error)")
                            } else {
                                if let isObject = object {
                                    let adventure = Appventure(object: isObject)
                                    if adventure.liveStatus != LiveStatus.inDevelopment {
                                        friendsAdventures.append(adventure)
                                        AppventureRating.loadRating(adventure, handler: nil)
                                    }
                                }
                                handler(friendsAdventures)
                            }
                        }
                    }
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
        
    }
    

}