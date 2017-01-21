//
//  BackendlessStep.swift
//  EA - Clues
//
//  Created by James Birtwell on 19/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class BackendlessStep : NSObject {
    
    static let backendless = Backendless.sharedInstance()
    static let dataStore = backendless?.persistenceService.of(BackendlessAppventure.ofClass())
    
    public var objectId: String?
    public var stepNumber: Int16?
    public var nameOrLocation: String?
    public var setup: BackendlessSetup?
    public var location: GeoPoint?
    
    init(step: AppventureStep) {
        self.objectId = step.backendlessId
        self.stepNumber = step.stepNumber
        self.nameOrLocation = step.nameOrLocation
        self.setup = BackendlessSetup(setup: step.setup)
        if let location = step.location {
        self.location = GeoPoint.geoPoint(
            GEO_POINT(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
            categories: ["Step"],
            metadata: ["Tag":"Great"]
            ) as? GeoPoint
        }
    }
    
    init(dict: Dictionary<String, Any>) {
        self.objectId = dict["objectId"] as? String
        self.stepNumber = dict["stepNumber"] as? Int16
        self.nameOrLocation = dict["nameOrLocation"] as? String
        print(dict["setup"] ?? "no setup")
    }
    
}
