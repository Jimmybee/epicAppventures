//
//  File.swift
//  EA - Clues
//
//  Created by James Birtwell on 17/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

typealias ServiceNewResponse = (AnyObject?, AnyObject?) -> ()

class BackendlessAppventure: NSObject {
    
    static let backendless = Backendless.sharedInstance()
    static let dataStore = backendless?.persistenceService.of(BackendlessAppventure.ofClass())

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
        self.subtitle = appventure.subtitle
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
    
    init(dict:  Dictionary<String, Any> ) {
        self.objectId = dict["objectId"] as? String
        self.duration = dict["duration"] as? String
        //        self.keyFeatures = appventure.keyFeatures!
        self.liveStatusNum = dict["liveStatusNum"] as! Int16
        self.title = dict["title"] as? String
        self.subtitle = dict["subtitle"] as? String
        self.totalDistance = dict["totalDistance"] as? Double
        self.location = dict["location"] as? GeoPoint
        
        if let stepDicts = dict["steps"] as? [Dictionary<String, Any>] {
            for stepDict in stepDicts {
                let step =  BackendlessStep(dict: stepDict)
                self.steps.append(step)
            }
        }
    }
    
    private func save(completion: @escaping (Dictionary<String, Any>) -> ()) {
        BackendlessAppventure.dataStore?.save(self, response: { (returnObject) in
            guard let dict = returnObject as? Dictionary<String, Any> else { return }
                        completion(dict)
            print(dict)
        }) { (error) in
            print(error ?? "no error?")
        }
    }
    
    static let apiUploadGroup = DispatchGroup()
    
    /// save an appventure to backend. Checks if objectId is nil as this is needed to pictureUrl
    class func save(appventure: Appventure, withImage: Bool, completion: @escaping () -> ()) {
        let backendlessAppventure = BackendlessAppventure(appventure: appventure)
        
        apiUploadGroup.enter()
        backendlessAppventure.save(completion: { (dict) in
            guard let objectId = dict["objectId"] as? String else { return }
            appventure.backendlessId = objectId
            guard let stepDicts = dict["steps"] as? [Dictionary<String, Any>] else { return }
            for (index, stepDict) in stepDicts.enumerated() {
                guard let  stepId = stepDict["objectId"] as? String else { return }
                appventure.appventureSteps[index].backendlessId = stepId
                guard let setupDict = stepDict["setup"] as? Dictionary<String, Any> else { return }
                guard let  setupId = setupDict["objectId"] as? String else { return }
                appventure.appventureSteps[index].setup.backendlessId = setupId
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
        
        let url = "myfiles/\(id)/image.jpg"
        let data = UIImagePNGRepresentation(image)
        
        apiUploadGroup.enter()
        BackendlessAppventure.backendless?.fileService.upload(
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
    
    
    class func loadBackendlessAppventures(persistent: Bool, dataQuery: BackendlessDataQuery, completion: @escaping ServiceNewResponse) {
        var appventures = [Appventure]()
        let dataStore = Backendless.sharedInstance().data.of(BackendlessAppventure.ofClass())
        dataStore?.find(dataQuery, response: { (collection) in
            let page1 = collection!.getCurrentPage()
            for obj in page1! {
                guard let dict = obj as? Dictionary<String, Any> else { return }
                let backendlessAppventure = BackendlessAppventure(dict: dict)
                let appventure = Appventure(backendlessAppventure: backendlessAppventure, persistent: persistent)
                appventures.append(appventure)
            }
            completion(appventures as AnyObject?, nil)
        }, error: { (fault) in
            print("Server reported an error: \(fault)")
            completion(nil, fault)
        })
    }
}


