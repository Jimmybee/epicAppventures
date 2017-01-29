//
//  FriendsAdventures.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

class SharedAdventure: NSObject {
    
    var creatorFbId: String?
    var shareeFbId: String?
    var appventureId: String?
    
    init(shareeFbId: String, appventureId: String) {
        self.creatorFbId = CoreUser.user!.facebookId!
        self.shareeFbId = shareeFbId
        self.appventureId = appventureId
    }
    
    
    func save(completion: @escaping () -> ()) {
        BackendlessAppventure.dataStore?.save(self, response: { (returnObject) in
            guard let dict = returnObject as? Dictionary<String, Any> else { return }
            completion()
            print(dict)
        }) { (error) in
            print(error ?? "no error?")
        }
    }
    
    
    static func fetchFriendAdventures(_ handler: ([Appventure]) -> Void) {
//        var friendsAdventures = [Appventure]()
//        if let user = User.user {
//            let query = PFQuery(className:parseCol.pfClass)
//            print("facebookid: \(user.facebookId)")
//            query.whereKey(parseCol.fbUserID, equalTo: user.facebookId)
//            query.limit = 100
//            var friendAdventures = [String]()
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [PFObject]?, error: NSError?) -> Void in
//                if error == nil {
//                    for object in objects! {
//                        let appventureID = object.objectForKey(parseCol.appventureFKID) as! String
//                        friendAdventures.append(appventureID)
//                    }
//                    let uniqueAdventureIDs = Array(Set(friendAdventures))
//
//                    for adventureID in uniqueAdventureIDs {
//                        let query = PFQuery(className: Appventure.pfAppventure.pfClass)
//                        query.getObjectInBackgroundWithId(adventureID) {
//                            (object: PFObject?, error: NSError?) -> Void in
//                            if error != nil {
//                                print("Get parse object error: /(error)")
//                            } else {
//                                if let isObject = object {
//                                    let adventure = Appventure(object: isObject)
//                                    if adventure.liveStatus != LiveStatus.inDevelopment {
//                                        friendsAdventures.append(adventure)
//                                        AppventureRating.loadRating(adventure, handler: nil)
//                                    }
//                                }
//                                handler(friendsAdventures)
//                            }
//                        }
//                    }
//                    
//                } else {
//                    // Log details of the failure
//                    print("Error: \(error!) \(error!.userInfo)")
//                }
//            }
//            
//        }
        
    }
    

}