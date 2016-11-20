//
//  ParseExtension.swift
//  EpicAppventures
//
//  Created by James Birtwell on 18/01/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation
import CoreLocation
//import Parse

class ParseFunc {
    
    static let objectIdColumn = "objectId"
    
    class func getParseObject(objectID:String, pfClass: String, objFunc: (object: AnyObject) -> ()) {
//        print("\(objectID) & \(pfClass)")
//        let query = PFQuery(className: pfClass)
//        query.getObjectInBackgroundWithId(objectID) {
//            (object: PFObject?, error: NSError?) -> Void in
//            if error != nil {
//                print("Get parse object error: /(error)")
//            } else {
//                print("Got object with id: \(object!.objectId!)")
//                objFunc(object: object!)
//            }
//        }
    }

    class func convertImage (image: UIImage) -> AnyObject? {
        let imageData = UIImagePNGRepresentation(image) as NSData!
//        let imageFile = PFFile(name:"image.png", data:imageData)
//        return imageFile!
        return nil
    }
    
    class func loadParseImage (pfFile: AnyObject, getParseImage: (UIImage) -> ()) -> (){
//        pfFile.getDataInBackgroundWithBlock {
//            (imageData: NSData?, error: NSError?) -> Void in
//            if error == nil {
//                if let imageData = imageData {
//                    if let image = UIImage(data: imageData) as UIImage! {
//                        getParseImage(image)
//                    }
//                } else {
//                    let errorString = error!.userInfo["error"] as? NSString
//                    print(errorString)
//                }
//            }
//            
//        }
        
    }
    
   class func loadImage(appventure: Appventure) {
        //Blocks main queue
//        if let pfImageFile = appventure.pfFile as PFFile! {
//            pfImageFile.getDataInBackgroundWithBlock {
//                (imageData: NSData?, error: NSError?) -> Void in
//                if error == nil {
//                    if let imageData = imageData {
//                        appventure.image = UIImage(data:imageData)
//                    } else {
//                        let errorString = error!.userInfo["error"] as? NSString
//                        print(errorString)
//                    }
//                }
//            }
//        }
    }
    
    class func parseQuery(className: String, location2D: CLLocationCoordinate2D?, whereClause: String?, WhereKey: String, vcHandler: ParseQueryHandler, handlerCase: String? = nil) {
        
//         print("\(className) & \(location2D) & \(whereClause) & \(WhereKey) & \(vcHandler) & \(handlerCase)")
//
//        let query = PFQuery(className: className)
//        
//        
//        if let clause = whereClause as String! {
//            query.whereKey(WhereKey, equalTo: clause)
//        } else if let point = location2D as CLLocationCoordinate2D! {
//            let geoPoint = PFGeoPoint(latitude: point.latitude, longitude: point.longitude)
//            query.whereKey(WhereKey, nearGeoPoint: geoPoint)
//        } else {
//            query.whereKeyExists(WhereKey)
//
//        }
//        
//        query.limit = 100
//        
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                print(objects?.count)
//                vcHandler.handleQueryResults(objects!, handlerCase: handlerCase)
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
    }
    
    class func queryAppventures(location2D: CLLocationCoordinate2D? = nil, liveStatus: Int? = nil, user: String? = nil, vcHandler: ParseQueryHandler, handlerCase: String) {
//        let query = PFQuery(className: Appventure.pfAppventure.pfClass)
//        
//        if let point = location2D {
//            let geoPoint = PFGeoPoint(latitude: point.latitude, longitude: point.longitude)
//            query.whereKey(Appventure.pfAppventure.pfCoordinate, nearGeoPoint: geoPoint)
//        }
//        
//        if let status = liveStatus {query.whereKey(Appventure.pfAppventure.pfStatus, equalTo: status)}
//        if let userString = user {query.whereKey(Appventure.pfAppventure.pfUserID, equalTo: userString)}
//        
//        query.limit = 100
//        
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                print("\(handlerCase) \(objects?.count)")
//                vcHandler.handleQueryResults(objects!, handlerCase: handlerCase)
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
        
    }
    
}

@objc protocol ParseQueryHandler: NSObjectProtocol {
    
    func handleQueryResults(objects: [AnyObject]?, handlerCase: String?)
    optional func handleSecondQueryResults(objects: [AnyObject])
    
    
}