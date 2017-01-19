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
    static let dataStore = backendless?.persistenceService.of(BackendlessAppventure1.ofClass())
    
    public var objectId: String?
    public var stepNumber: Int16?
    public var nameOrLocation: String?
    
    init(step: AppventureStep) {
        self.objectId = step.backendlessId
        self.stepNumber = step.stepNumber
        self.nameOrLocation = step.nameOrLocation
    }
    
}
