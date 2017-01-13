//
//  DummyAppventure.swift
//  EA - Clues
//
//  Created by James Birtwell on 22/11/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation


class BackendlessAppventure: NSObject {
    
    var objectId: String?
    var userId: String?
    var title: String?
    var keyFeatures: String
    var totalDistance: Double = 0.0
    var rating: Int16 = 0
    var pictureURL: String?
    var duration: String?
    var restrictions: String
    var startingLocationName: String?
    var subtitle: String?
    var startingCoordinate: GeoPoint?
    
    //UpdateForBackendlessSave
     var liveStatusInt: Int16 = 2
    
    init(appventure: Appventure) {
        self.objectId = appventure.backendObjectId
        self.userId = appventure.userID
        self.title = appventure.title
        self.keyFeatures = appventure.keyFeatures.joined(separator: ",")
        self.pictureURL = appventure.pictureURL
        self.restrictions = appventure.keyFeatures.joined(separator: ",")
        self.startingCoordinate?.latitude(appventure.coordinateLat)
        self.startingCoordinate?.longitude(appventure.coordinateLon)
    }
    
    func saveToBackendless(_ handler: @escaping (String?) -> ()) {
        let backendless = Backendless.sharedInstance()
        backendless?.persistenceService.of(BackendlessAppventure.ofClass()).save(self, response: { (result) in

            if let saveDict = result as? NSDictionary {
                    let objectId = saveDict.value(forKeyPath: "objectId") as? String
                    handler(objectId)
            }
            
        }) { (fault) in
            print(fault)
            handler(nil)
        }
   
    }
    
    static func loadFromBackendless(_ handler: ([Appventure]) -> () ) {
        
    }
    
    static func uploadDataToBackendlessUrl(_ imageId: String, data: Data, handler: @escaping (String?) -> ()) {
        
        print("\n============ Uploading files with the ASYNC API ============")
        
        let backendless = Backendless.sharedInstance()
        backendless.fileService.upload(
            ("images/\(imageId).png"),
            content: data,
            overwrite:true,
            response: { ( uploadedFile : BackendlessFile!) -> () in
                print("File has been uploaded. File URL is - \(uploadedFile.fileURL)")
                handler(uploadedFile.fileURL)
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
                handler(nil)
        })
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
