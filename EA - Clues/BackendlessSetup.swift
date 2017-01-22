//
//  BackendlessSetup.swift
//  EA - Clues
//
//  Created by James Birtwell on 21/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class BackendlessSetup: NSObject {
 
     public var textClue: Bool
     public var soundClue: Bool
     public var pictureClue: Bool
     public var checkIn: Bool
     public var isLocation: Bool
     public var locationShown: Bool
     public var compassShown: Bool
     public var distanceShown: Bool
     public var objectId: String!
    
    init(setup: StepSetup) {
        self.objectId = setup.backendlessId
        self.textClue = setup.textClue
        self.soundClue = setup.soundClue
        self.pictureClue = setup.pictureClue
        self.checkIn = setup.checkIn
        self.isLocation  = setup.isLocation
        self.locationShown = setup.locationShown
        self.compassShown = setup.compassShown
        self.distanceShown = setup.distanceShown
    }
    
    init(dict: Dictionary<String, Any>) {
        self.objectId = dict["objectId"] as? String
        self.textClue = dict["textClue"] as! Bool
        self.soundClue = dict["soundClue"] as! Bool
        self.pictureClue = dict["pictureClue"] as! Bool
        self.checkIn = dict["checkIn"] as! Bool
        self.isLocation  = dict["isLocation"] as! Bool
        self.locationShown = dict["locationShown"] as! Bool
        self.compassShown = dict["compassShown"] as! Bool
        self.distanceShown = dict["distanceShown"] as! Bool
    }
}
