//
//  File.swift
//  EA - Clues
//
//  Created by James Birtwell on 08/10/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation
import CoreLocation
//import Parse
import CoreData

extension Appventure {
//    struct pfAppventure {
//        static let pfClass = "Appventure"
//        static let pfTitle = "appventureName"
//        static let pfSubtitle = "shortDescription"
//        static let pfCoordinate = "startingPoint"
//        static let pfRating = "rating"
//        static let pfNumOfRatings = "numOfRatings"
//        static let pfUserID = "OwnerId"
//        static let pfAppventureImage = "appventureImage"
//        static let pfTotalDistance = "totalDistance"
//        static let pfDuration = "duration"
//        static let pfStartingLocationName = "startingLocationName"
//        static let pfKeyFeatures = "keyFeatures"
//        static let pfRestrictions = "restrictions"
//        static let pfStatus = "status"
//    }
    

    
    class func loadLiveAdventures(_ location2D: CLLocationCoordinate2D, handler: ParseQueryHandler, handlerCase: String) {
//        ParseFunc.queryAppventures(location2D, liveStatus: LiveStatus.live.rawValue, vcHandler: handler, handlerCase: handlerCase)
    }
    
    class func loadUserAppventure(_ userPFID: String, handler: ParseQueryHandler, handlerCase: String) {
//        ParseFunc.queryAppventures(user: userPFID, vcHandler: handler, handlerCase: handlerCase)
        //        ParseFunc.parseQuery(pfAppventure.pfClass, location2D: nil, whereClause: userPFID, WhereKey: pfAppventure.pfUserID, vcHandler: handler)
    }
    

    fileprivate func saveObject(_ save: AnyObject) {
//        if self.appventureSteps.count > 0 {
//            if CLLocationCoordinate2DIsValid(appventureSteps[0].coordinate) {
//                self.coordinate = appventureSteps[0].coordinate
//                let point = PFGeoPoint(latitude: self.coordinate!.latitude, longitude: self.coordinate!.longitude)
//                save[pfAppventure.pfCoordinate] = point
//            }
//        }
//        let currentUser = PFUser.currentUser()
//        save[pfAppventure.pfTitle] = self.title
//        save[pfAppventure.pfSubtitle] = self.subtitle
//        save[pfAppventure.pfUserID] = currentUser?.objectId!
//        if let image = self.image {
//            save[pfAppventure.pfAppventureImage] = HelperFunctions.convertImage(image)
//        }
//        save[pfAppventure.pfTotalDistance] = self.totalDistance
//        save[pfAppventure.pfStartingLocationName] = self.startingLocationName
//        save[pfAppventure.pfDuration] = self.duration
//        save[pfAppventure.pfKeyFeatures] = self.keyFeatures.joinWithSeparator(",")
//        save[pfAppventure.pfRestrictions] = self.restrictions.joinWithSeparator(",")
//        save[pfAppventure.pfStatus] = self.liveStatus.rawValue
//        save[pfAppventure.pfRating] = self.rating
//        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if let error = error {
//                let errorString = error.userInfo["error"] as? NSString
//                print("saveAppventure: \(errorString)")
//            } else {
//                self.pFObjectID = save.objectId!
//                self.saved = true
//            }
//        }
    }
    
    func deleteAppventureFromBackend() {
//        let query = PFQuery(className: Appventure.pfAppventure.pfClass)
//        query.getObjectInBackgroundWithId(self.pFObjectID!) {
//            (object: PFObject?, error: NSError?) -> Void in
//            if error != nil {
//                print("delete error \(error)")
//            } else {
//                object?.deleteInBackground()
//            }
//        }
        
        
        
    }
}
