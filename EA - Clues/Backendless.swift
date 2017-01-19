//
//  File.swift
//  EA - Clues
//
//  Created by James Birtwell on 17/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation


extension Appventure {
    
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



class BackendlessAppventure1: NSObject {
    
    static let backendless = Backendless.sharedInstance()
    static let dataStore = backendless?.persistenceService.of(BackendlessAppventure1.ofClass())

    public var objectId: String?
    
    public var duration: String?
//    public var keyFeatures = [String]()
    public var liveStatusNum: Int16 = 0
//    public var restrictions: [String]?
    public var startingLocationName: String?
    public var subtitle: String?
    public var title: String?
    public var totalDistance: Double? = 0
    public var location: GeoPoint?
    public var steps: [BackendlessStep] = []
    
    init(appventure: Appventure) {
        self.duration = appventure.duration
//        self.keyFeatures = appventure.keyFeatures!
        self.liveStatusNum = appventure.liveStatusNum
        self.objectId = appventure.backendlessId
        self.title = appventure.title!
        self.totalDistance = appventure.totalDistance
        self.location = GeoPoint.geoPoint(
            GEO_POINT(latitude: appventure.location.coordinate.latitude, longitude: appventure.location.coordinate.longitude),
            categories: ["Appventure"],
            metadata: ["Tag":"Great"]
            ) as? GeoPoint
        for step in appventure.steps {
            let backendlessStep = BackendlessStep(step: step)
            self.steps.append(backendlessStep)
        }
    }
    
    private func save(completion: @escaping (String?, [String]?) -> ()) {
        BackendlessAppventure1.dataStore?.save(self, response: { (returnObject) in
            guard let dict = returnObject as? Dictionary<String, Any> else { return }
            guard let objectId = dict["objectId"] as? String else { return }
            guard let steps = dict["steps"] as? [Dictionary<String, Any>] else { return }
            var stepIds = [String]()
            for step in steps {
                if let stepId = step["objectId"] as? String {
                    stepIds.append(stepId)
                }
            }
            completion(objectId, stepIds)
        }) { (error) in
            print(error ?? "no error?")
        }
    }
    
    static let apiUploadGroup = DispatchGroup()
    
    /// save an appventure to backend. Checks if objectId is nil as this is needed to pictureUrl
    class func save(appventure: Appventure, withImage: Bool, completion: @escaping () -> ()) {
        let backendlessAppventure = BackendlessAppventure1(appventure: appventure)
        
        apiUploadGroup.enter()
        backendlessAppventure.save(completion: { (objectId, stepIds) in
            appventure.backendlessId = objectId
            for (index, objectId) in stepIds!.enumerated() {
                appventure.appventureSteps[index].backendlessId = objectId
            }
            if withImage == true {
                uploadImageAsync(objectId: appventure.backendlessId, image: appventure.image, completion: { () in

                })
            }
            for step in appventure.appventureSteps {
                uploadImageAsync(objectId: step.backendlessId, image: step.image, completion: {
                })
            }
            apiUploadGroup.leave()
        })
        
        apiUploadGroup.notify(queue: .main) {
            print("notified")
            completion()
        }
        
        
    }
    
    class func uploadImageAsync(objectId: String?, image: UIImage?, completion: @escaping () -> ()) {
        print("\n============ Uploading files with the ASYNC API ============")
        guard  let image = image  else { return }
        guard let id = objectId else { return }
        
        let url = "myfiles/\(id)/appventure.jpg"
        let data = UIImagePNGRepresentation(image)
        
        apiUploadGroup.enter()
        BackendlessAppventure1.backendless?.fileService.upload(
            url,
            content: data,
            overwrite:true,
            response: { ( uploadedFile ) in
                print("File has been uploaded. File URL is - \(uploadedFile?.fileURL)")
                apiUploadGroup.leave()
                completion()
        },
            error: { ( fault ) in
                print("Server reported an error: \(fault)")
        })
    }
}
