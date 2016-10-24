//
//  AppventureRating.swift
//  EA - Clues
//
//  Created by James Birtwell on 19/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation
import Parse

protocol AppventureRatingDelegate : NSObjectProtocol {
    func ratingLoaded()
}

class AppventureRating: NSObject {
    
    static let appventureRatingHC = "ratingsHC"
    
    
    struct parseCol {
        static let pfClass = "Rating"
        static let userFKID = "userID"
        static let appventureFKID = "appventureFKID"
        static let rating = "rating"
        static let numberOfRatings = "numberOfRatings"
    }
    
    
    var pfObjectID = ""
    var userFKID = ""
    var appventureFKID = ""
    var rating = 0
    
    override init() {
    
    }
    
    init(userFKID: String, appventureFKID: String, rating: Int) {
        self.userFKID = userFKID
        self.appventureFKID = appventureFKID
        self.rating = rating
    }
    
    init(object: PFObject) {
        self.pfObjectID = object.objectId!
        self.userFKID = object.objectForKey(parseCol.userFKID) as! String
        self.appventureFKID = object.objectForKey(parseCol.appventureFKID) as! String
        self.rating = object.objectForKey(parseCol.rating) as! Int
    }
    
    func save(){
        if self.pfObjectID == "" {
            let saveObj = PFObject(className: parseCol.pfClass)
            saveObject(saveObj)
        } else {
            ParseFunc.getParseObject(self.pfObjectID, pfClass:  parseCol.pfClass, objFunc: saveObject)
        }
    }
    
    private func saveObject(save: PFObject) {
        save[parseCol.userFKID] = self.userFKID
        save[parseCol.appventureFKID] = self.appventureFKID
        save[parseCol.rating] = self.rating
        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
            } else {
                self.pfObjectID = save.objectId!
                print("savedRatings")
            }
        }
    }
    
    
    class func loadRating(appventure: Appventure, handler: AppventureRatingDelegate?) {
        let query = PFQuery(className:parseCol.pfClass)
        query.whereKey(parseCol.appventureFKID, equalTo: appventure.pFObjectID!)
        query.limit = 100
        var ratingArray = [Double]()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object in objects! {
                    let appventureRating = AppventureRating(object: object)
                    ratingArray.append(Double(appventureRating.rating))
                }
                let ratingAvg = ratingArray.reduce(0, combine: +) / Double(ratingArray.count)
                ratingAvg > 0 ? (appventure.rating = Int(round(ratingAvg))) : (appventure.rating = 3)
                handler?.ratingLoaded()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    
}
