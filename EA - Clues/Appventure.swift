//
//  Appventure.swift
//  MapPlay
//
//  Created by James Birtwell on 09/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
import MapKit
import Parse

 class Appventure: NSObject {
    
    static private var currentAppventure: Appventure?
    
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
    
    var PFObjectID: String?
    var userID: String?
    var title: String? = ""
    var subtitle: String? = ""
    var coordinate: CLLocationCoordinate2D? = kCLLocationCoordinate2DInvalid
    var startingLocationName = ""
    var totalDistance:Double! = 0.0
    var duration = ""
    var image:UIImage? 
    var pfFile: PFFile?
    var keyFeatures = [String]()
    var restrictions = [String]()
    var liveStatus:LiveStatus = .inDevelopment
    
    
    //updates separately
    //    var interactivity = Filter.interactivityTypes.Static
    
    var appventureSteps = [AppventureStep]()
    var appventureRating = AppventureRating()
    
    //non-parse
    var saved = true
    var distanceToSearch = 0.0
    var tags: [String]?
    var rating = 2
    
    override  init() {
        
    }
    
     init(PFObjectID: String, name: String, geoPoint: PFGeoPoint) {
        self.title = name
        self.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
        self.PFObjectID = PFObjectID
    }
    
    init(object: PFObject) {
        self.PFObjectID = object.objectId
        self.title = object.objectForKey(pfAppventure.pfTitle) as? String
        self.subtitle = object.objectForKey(pfAppventure.pfSubtitle) as? String
        self.pfFile = object.objectForKey(Appventure.pfAppventure.pfAppventureImage) as? PFFile
        if let point = object.objectForKey(Appventure.pfAppventure.pfCoordinate) as? PFGeoPoint {
            self.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
        }
        self.userID = object[pfAppventure.pfUserID] as? String
        self.totalDistance = object[Appventure.pfAppventure.pfTotalDistance] as? Double
        self.duration = object[pfAppventure.pfDuration] as! String
        self.startingLocationName = object[pfAppventure.pfStartingLocationName] as! String
        let tempString  = object[pfAppventure.pfKeyFeatures] as! String
        self.keyFeatures = tempString.splitStringToArray()
        let tempString2 = object[pfAppventure.pfRestrictions] as! String
        self.restrictions  = tempString2.splitStringToArray()
        if let status = object[pfAppventure.pfStatus] as? Int {
            self.liveStatus = LiveStatus(rawValue: status)!
        }
    }
    
    init(appventure: Appventure) {
        self.PFObjectID = appventure.PFObjectID
        self.title = appventure.title
        self.subtitle = appventure.subtitle
        self.pfFile = appventure.pfFile
        self.coordinate = appventure.coordinate
        self.totalDistance = appventure.totalDistance
        self.startingLocationName = appventure.startingLocationName
        self.duration = appventure.duration
        self.image = appventure.image
        self.keyFeatures = appventure.keyFeatures
        self.restrictions = appventure.restrictions
        self.liveStatus = appventure.liveStatus
        self.rating = appventure.rating

    }
    
    class func loadLiveAdventures(location2D: CLLocationCoordinate2D, handler: ParseQueryHandler, handlerCase: String) {
        ParseFunc.queryAppventures(location2D, liveStatus: LiveStatus.live.rawValue, vcHandler: handler, handlerCase: handlerCase)
    }
    
    class func loadUserAppventure(userPFID: String, handler: ParseQueryHandler, handlerCase: String) {
        ParseFunc.queryAppventures(user: userPFID, vcHandler: handler, handlerCase: handlerCase)
//        ParseFunc.parseQuery(pfAppventure.pfClass, location2D: nil, whereClause: userPFID, WhereKey: pfAppventure.pfUserID, vcHandler: handler)
    }
    
    func save() {
        if self.PFObjectID == nil {
            let saveObj = PFObject(className: pfAppventure.pfClass)
            saveObject(saveObj)
        } else {
            ParseFunc.getParseObject(self.PFObjectID!, pfClass:  pfAppventure.pfClass, objFunc: saveObject)

        }
    }
    
    private func saveObject(save: PFObject) {
        if self.appventureSteps.count > 0 {
            if CLLocationCoordinate2DIsValid(appventureSteps[0].coordinate) {
                self.coordinate = appventureSteps[0].coordinate
                let point = PFGeoPoint(latitude: self.coordinate!.latitude, longitude: self.coordinate!.longitude)
                save[pfAppventure.pfCoordinate] = point
            }
        }
        let currentUser = PFUser.currentUser()
        save[pfAppventure.pfTitle] = self.title
        save[pfAppventure.pfSubtitle] = self.subtitle
        save[pfAppventure.pfUserID] = currentUser?.objectId!
        if let image = self.image {
            save[pfAppventure.pfAppventureImage] = HelperFunctions.convertImage(image)
        }
        save[pfAppventure.pfTotalDistance] = self.totalDistance
        save[pfAppventure.pfStartingLocationName] = self.startingLocationName
        save[pfAppventure.pfDuration] = self.duration
        save[pfAppventure.pfKeyFeatures] = self.keyFeatures.joinWithSeparator(",")
        save[pfAppventure.pfRestrictions] = self.restrictions.joinWithSeparator(",")
        save[pfAppventure.pfStatus] = self.liveStatus.rawValue
        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print("saveAppventure: \(errorString)")
            } else {
                self.PFObjectID = save.objectId!
                self.saved = true
            }
        }
    }
    
    func deleteAppventure() {
        let query = PFQuery(className: Appventure.pfAppventure.pfClass)
        query.getObjectInBackgroundWithId(self.PFObjectID!) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print("delete error \(error)")
            } else {
                object?.deleteInBackground()
            }
        }

    }
    
    static func currentAppventureID() -> String? {
        return Appventure.currentAppventure?.PFObjectID
    }
    
    static func setCurrentAppventure(appventure: Appventure) {
        Appventure.currentAppventure = appventure
    }
    
}

enum LiveStatus: Int {
    case live = 0
    case waitingForApproval = 1
    case inDevelopment = 2
    case local = 3
    
    var label: String {
        switch self {
        case .live: return "Live"
        case .waitingForApproval: return "Awaiting Approval"
        case .inDevelopment: return "In Develoopment"
        case .local: return "Local"
        }
    }
    
    func segmentValue() -> Int {
        switch self {
        case .inDevelopment: return 0
        case .local: return 1
        case .waitingForApproval: return 2
        case .live: return 3
        }
    }
}