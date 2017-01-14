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
    struct pfAppventure {
        static let pfClass = "Appventure"
        static let pfTitle = "appventureName"
        static let pfSubtitle = "shortDescription"
        static let pfCoordinate = "startingPoint"
        static let pfRating = "rating"
        static let pfNumOfRatings = "numOfRatings"
        static let pfUserID = "OwnerId"
        static let pfAppventureImage = "appventureImage"
        static let pfTotalDistance = "totalDistance"
        static let pfDuration = "duration"
        static let pfStartingLocationName = "startingLocationName"
        static let pfKeyFeatures = "keyFeatures"
        static let pfRestrictions = "restrictions"
        static let pfStatus = "status"
    }
    
    convenience init(PFObjectID: String, name: String, geoPoint: AnyObject) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: nil)
//        self.title = name
//        self.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
//        self.pFObjectID = PFObjectID
    }
    
    convenience init(object: AnyObject) {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: nil)
//        self.pFObjectID = object.objectId
//        self.title = object.objectForKey(pfAppventure.pfTitle) as? String
//        self.subtitle = object.objectForKey(pfAppventure.pfSubtitle) as? String
//        self.pfFile = object.objectForKey(Appventure.pfAppventure.pfAppventureImage) as? PFFile
//        if let point = object.objectForKey(Appventure.pfAppventure.pfCoordinate) as? PFGeoPoint {
//            self.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
//        }
//        self.userID = object[pfAppventure.pfUserID] as? String
//        self.totalDistance = object[Appventure.pfAppventure.pfTotalDistance] as! Double
//        self.duration = object[pfAppventure.pfDuration] as? String
//        self.startingLocationName = object[pfAppventure.pfStartingLocationName] as? String
//        let tempString  = object[pfAppventure.pfKeyFeatures] as! String
//        self.keyFeatures = tempString.splitStringToArray()
//        let tempString2 = object[pfAppventure.pfRestrictions] as! String
//        self.restrictions  = tempString2.splitStringToArray()
//        if let status = object[pfAppventure.pfStatus] as? Int {
//            self.liveStatus = LiveStatus(rawValue: status)!
//        }
//        if let rating = object[pfAppventure.pfRating] as? Int {self.rating = rating}
    }
    
    func saveToParse() {
//        if self.pFObjectID == nil {
//            let saveObj = PFObject(className: pfAppventure.pfClass)
//            saveObject(saveObj)
//        } else {
//            ParseFunc.getParseObject(self.pFObjectID!, pfClass:  pfAppventure.pfClass, objFunc: saveObject)
//        }
    }
    
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
