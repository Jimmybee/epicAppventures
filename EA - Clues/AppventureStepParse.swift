//
//  File.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/10/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation
//import Parse

extension AppventureStep {
    struct pfStep {
        static let pfClass = "AppventureStep"
        static let pfStepNumber = "stepNumber"
        static let pfNameOrLocation = "nameOrLocation"
        static let pfCheckInProximity = "checkInProximity"
        static let pfLocationSubtitle = "locationSubtitle"
        static let pfGeoPoint = "coordinate"
        static let pfInitialText = "intialText"
        static let pfAnswerText = "answerTextArray"
        static let pfAppventureIDKey = "appventureID"
        static let pfAnswerHintText = "answerHintArray"
        static let pfAnswerFormatText = "answerFormat"
        static let pfCompletionText = "completionText"
        static let pfStepImage = "stepImage"
        static let pfStepSound = "stepSound"
        static let pfFreeHints = "freeHints"
        static let pfHintPenalty = "hintPenalty"
        static let pfSetup = "Setup"
        
    }

    
    convenience init(object: AnyObject) {
        self.init()
//        self.pFObjectID = object.objectId as String!
//        self.appventurePFObjectID = object.objectForKey(pfStep.pfAppventureIDKey) as? String
//        self.nameOrLocation = object.objectForKey(pfStep.pfNameOrLocation) as? String
//        if  let checkInProximity = object.objectForKey(pfStep.pfCheckInProximity) as? Int {
//            self.checkInProximity = Int16(checkInProximity)
//        }
//        if let  locationSubtitle = object.objectForKey(pfStep.pfLocationSubtitle) as?  String {
//            self.locationSubtitle = locationSubtitle
//        }
//        self.initialText = object.objectForKey(pfStep.pfInitialText) as? String
//        if let answerArray = object.objectForKey(pfStep.pfAnswerText) as? [String] {
//            self.answerText = answerArray
//        }
//        if let hintArray = object.objectForKey(pfStep.pfAnswerHintText) as? [String] {
//            self.answerHint = hintArray
//        }
//        self.completionText = object.objectForKey(pfStep.pfCompletionText) as? String
//        if let stepNumber = object.objectForKey(pfStep.pfStepNumber) as? Int {
//             self.stepNumber = Int16(stepNumber)
//        }
//        if let freeHints = object.objectForKey(pfStep.pfFreeHints) as? Int {
//            self.freeHints = Int16(freeHints)
//        }
//        if let penalty = object.objectForKey(pfStep.pfHintPenalty) as? Int {
//            self.hintPenalty = Int16(penalty)
//        }
//        self.saved = true
//        self.imagePFFile = object[pfStep.pfStepImage] as? PFFile
//        self.soundPFFile = object[pfStep.pfStepSound] as? PFFile
//        let setupString = object[pfStep.pfSetup] as! String
//        self.setup = AppventureStep.convertStringToDictionary(setupString)!
//        if let point = object.objectForKey(pfStep.pfGeoPoint) as? PFGeoPoint {
//            self.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
//        } else {
//            self.coordinate = CLLocationCoordinate2D()
//        }
    }
    
    func saveAndSync() {
        self.saveBackend()
        self.updateCoreDataBridges()
        do {
            try self.managedObjectContext?.save()
        } catch let error as NSError  {
            print("Could not save to CD.. \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func saveBackend(){
        if self.pFObjectID == "" {
//            let saveObj = PFObject(className: pfStep.pfClass)
//            saveObject(saveObj)
        } else {
//            ParseFunc.getParseObject(self.pFObjectID!, pfClass:  pfStep.pfClass, objFunc: saveObject)
        }
    }
    
    fileprivate func saveObject(_ save: AnyObject) {
//        if let jsonString = convertDictToJson(self.setup) {
//            save[pfStep.pfSetup] = jsonString
//            print(jsonString)
//        }
//        if let isImage = self.image as UIImage! {
//            save[pfStep.pfStepImage] = HelperFunctions.convertImage(isImage)
//        }
//        if let isSound = self.sound as NSData! {
//            save[pfStep.pfStepSound] = PFFile(name: "sound.caf", data: isSound)
//        }
//        save[pfStep.pfAppventureIDKey] = self.appventurePFObjectID
//        save[pfStep.pfNameOrLocation] = self.nameOrLocation
//        save[pfStep.pfLocationSubtitle] = self.locationSubtitle
//        save[pfStep.pfInitialText] = self.initialText
//        save[pfStep.pfAnswerText] = self.answerText
//        save[pfStep.pfAnswerHintText] = self.answerHint
//        save[pfStep.pfAnswerFormatText] = self.answerFormatHint
//        save[pfStep.pfStepNumber] = Int(self.stepNumber)
//        save[pfStep.pfCompletionText] = self.completionText
//        save[pfStep.pfCheckInProximity] = Int(self.checkInProximity)
//        save[pfStep.pfFreeHints] = Int(self.freeHints)
//        save[pfStep.pfHintPenalty] = Int(self.hintPenalty)
//        save[pfStep.pfGeoPoint] = PFGeoPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
//        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            if let error = error {
//                let errorString = error.userInfo["error"] as? NSString
//                print(errorString)
//            } else {
//                self.pFObjectID = save.objectId!
//                print("savedStep")
//            }
//        }
    }
    

    class func loadSteps(_ appventure: Appventure, handler: () -> ()) {
//        let query = PFQuery(className: pfStep.pfClass)
//        query.whereKey(pfStep.pfAppventureIDKey, equalTo: appventure.pFObjectID!)
//        query.limit = 20
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                appventure.appventureSteps.removeAll()
//                for object in objects! {
//                    let step = AppventureStep(object: object)
//                    appventure.appventureSteps.append(step)
//                }
//                self.getStepData(appventure, handler: handler)
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
    }
    
    fileprivate class func getStepData(_ appventure: Appventure, handler: () -> ()) {
//        print("Appventure \(appventure.title!)")
//        dataLoads[appventure.pFObjectID!] = 100
//        for step in appventure.appventureSteps {
//            if let soundFile = step.soundPFFile as PFFile! {
//                dataLoads[appventure.pFObjectID!]! += 1
//                soundFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
//                    self.dataLoads[appventure.pFObjectID!]! -= 1
//                    if error == nil {
//                        step.sound = data
//                    }
//                    self.checkAndSave(appventure, handler: handler)
//                })
//            }
//            if let imageFile = step.imagePFFile as PFFile! {
//                dataLoads[appventure.pFObjectID!]! += 1
//                imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
//                    self.dataLoads[appventure.pFObjectID!]! -= 1
//
//                    if error == nil {
//                        if let dataFound = data {
//                            step.image = UIImage(data: dataFound)
//                        }
//                    }
//                    self.checkAndSave(appventure, handler: handler)
//                })
//            }
//        
//        }
//        self.dataLoads[appventure.pFObjectID!]! -= 100
//        self.checkAndSave(appventure, handler: handler)

    }
    
    fileprivate class func checkAndSave(_ appventure: Appventure, handler: () -> ()) {
        
//        print("Appventure: \(appventure.title)  & loads:\(dataLoads[appventure.pFObjectID!])")
        if dataLoads[appventure.pFObjectID!] == 0 {
            appventure.saveToCoreData(handler)
        }
    }
    
    
}
