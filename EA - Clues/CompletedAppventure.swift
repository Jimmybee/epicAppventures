//
//  Review.swift
//  EpicAppventures
//
//  Created by James Birtwell on 27/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
//import Parse

 class CompletedAppventure: NSObject {
    
    static let allCompletedHC = "allCompletedAppventures"
    
    struct parseCol {
        static let pfClass = "CompletedAppventure"
        static let userFKID = "userID"
        static let date = "date"
        static let appventureFKID = "appventureFKID"
        static let time = "time"
        static let teamName = "teamName"
    }
 
    
     var pfObjectID = ""
     var userFKID = ""
     var teamName = ""
     var appventureFKID = ""
     var date = Date()
     var time = 0.0
    
    init(userFKID: String, teamName: String, appventureFKID: String, date: Date, time: Double) {
        self.userFKID = userFKID
        self.teamName = teamName
        self.appventureFKID = appventureFKID
        self.date = date
        self.time = time
    }
    
    init(object: AnyObject) {
//        self.pfObjectID = object.objectId!
//        self.userFKID = object.objectForKey(parseCol.userFKID) as! String
//        self.appventureFKID = object.objectForKey(parseCol.appventureFKID) as! String
//        self.teamName = object.objectForKey(parseCol.teamName) as! String
//        self.date = object.objectForKey(parseCol.date) as! NSDate
//        self.time = object.objectForKey(parseCol.time) as! Double
    }
    
    func save(){
//        if self.pfObjectID == "" {
//            let saveObj = PFObject(className: parseCol.pfClass)
//            saveObject(saveObj)
//        } else {
//            ParseFunc.getParseObject(self.pfObjectID, pfClass:  parseCol.pfClass, objFunc: saveObject)
//        }
    }
    
    fileprivate func saveObject(_ save: AnyObject) {
//        save[parseCol.userFKID] = self.userFKID
//        save[parseCol.appventureFKID] = self.appventureFKID
//        save[parseCol.teamName] = self.teamName
//        save[parseCol.date] = self.date
//        save[parseCol.time] = self.time
//        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if let error = error {
//                let errorString = error.userInfo["error"] as? NSString
//                print(errorString)
//            } else {
//                self.pfObjectID = save.objectId!
//                print("savedCompleted")
//            }
//        }
    }
    
    class func loadAppventuresCompleted(_ appventureID: String, handler: ParseQueryHandler) {
//        ParseFunc.parseQuery(parseCol.pfClass, location2D: nil, whereClause: appventureID, WhereKey: parseCol.appventureFKID, vcHandler: handler, handlerCase: allCompletedHC)
    }
    
    class func loadUserCompleted(_ userID: String, handler: ParseQueryHandler) {
//        ParseFunc.parseQuery(parseCol.pfClass, location2D: nil, whereClause: userID, WhereKey: parseCol.userFKID, vcHandler: handler)
    }
    
    class func countCompleted(_ handler: AppventureCompletedDelegate) {
//        let query = PFQuery(className:parseCol.pfClass)
//        query.whereKey(parseCol.userFKID, equalTo: User.user!.pfObject)
//        query.limit = 100
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                if let counted = objects?.count {
//                    User.user?.completedAdventures = counted
//                    handler.countCompleted()
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
    }


}

protocol AppventureCompletedDelegate {
    func countCompleted()
}
